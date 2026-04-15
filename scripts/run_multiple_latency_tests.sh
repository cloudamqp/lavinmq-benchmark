#!/bin/bash

# Script to run multiple latency tests with different message sizes and rate limits
# Usage: ./run_multiple_latency_tests.sh <broker_ip> [size1,size2,...] [rate1,rate2,...] [duration] [broker_instance_type] [num_runs] [per_size_rate_limits]
#   per_size_rate_limits format: "16:10,100,500000|64:10,100,450000" (size:rates pairs separated by |)

set -e  # Exit on error

# Function to format numbers with thousand separators
format_number() {
  local num="$1"
  # Use printf with locale if available, otherwise use sed
  LC_NUMERIC=en_US.UTF-8 printf "%'d" "$num" 2>/dev/null || \
    echo "$num" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

BROKER_IP="${1}"
SIZES="${2:-16,64,256,512,1024}"  # Default sizes if not provided
RATE_LIMITS="${3:-10,100,1000,10000,50000,100000,200000,500000}"  # Default rate limits
DURATION="${4:-120}"  # Default duration 120 seconds if not provided
BROKER_INSTANCE_TYPE="${5:-unknown}"  # Broker instance type for reporting
NUM_RUNS="${6:-${BENCHMARK_NUM_RUNS:-1}}"  # Number of runs per combination, default 1
PER_SIZE_RATE_LIMITS="${7:-}"              # Optional per-size rate limits, format: "size1:r1,r2|size2:r1,r2"
OUTPUT_FILE="/home/ubuntu/latency_results.md"
TEMP_DIR="/tmp/latency_test_$$"
QUEUE_NAME="perf-test"

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  echo "Usage: $0 <broker_ip> [size1,size2,...] [rate1,rate2,...] [duration] [broker_instance_type] [num_runs] [per_size_rate_limits]"
  exit 1
fi

# Create temp directory
mkdir -p "$TEMP_DIR"

# Fetch LavinMQ version from broker API
echo "Fetching LavinMQ version from broker..."
OVERVIEW_RESPONSE=$(curl -s --request GET \
  --url "http://$BROKER_IP:15672/api/overview" \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=')

# Parse lavinmq_version from JSON response
LAVINMQ_VERSION=$(echo "$OVERVIEW_RESPONSE" | grep -o '"lavinmq_version":"[^"]*"' | cut -d'"' -f4)

if [ -z "$LAVINMQ_VERSION" ]; then
  LAVINMQ_VERSION="Unknown (failed to fetch)"
fi

echo "=========================================="
echo "Multiple Latency Test Runner"
echo "=========================================="
echo "Broker IP: $BROKER_IP"
echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
echo "LavinMQ Version: $LAVINMQ_VERSION"
echo "Message Sizes: $SIZES"
echo "Rate Limits: $RATE_LIMITS msgs/s"
echo "Per-Size Rate Limits: ${PER_SIZE_RATE_LIMITS:-(using global rate limits)}"
echo "Test Duration: $DURATION seconds"
echo "Number of Runs: $NUM_RUNS"
echo "Output File: $OUTPUT_FILE"
echo "=========================================="
echo ""

# Convert comma-separated values to arrays
IFS=',' read -ra SIZE_ARRAY <<< "$SIZES"
IFS=',' read -ra RATE_ARRAY <<< "$RATE_LIMITS"

# Parse per-size rate limits into associative array (format: "16:10,100,500000|64:10,100,450000")
declare -A SIZE_RATE_MAP
if [ -n "$PER_SIZE_RATE_LIMITS" ]; then
  IFS='|' read -ra SIZE_RATE_PAIRS <<< "$PER_SIZE_RATE_LIMITS"
  for PAIR in "${SIZE_RATE_PAIRS[@]}"; do
    SIZE_RATE_MAP["${PAIR%%:*}"]="${PAIR#*:}"
  done
fi

# Initialize CSV files for each size
for SIZE in "${SIZE_ARRAY[@]}"; do
  SIZE_CSV="$TEMP_DIR/size_${SIZE}.csv"
  echo "Run,RateLimit,Min,Median,P75,P95,P99,PubRate,PubBW,ConBW" > "$SIZE_CSV"
done

# Run tests: outer loop = runs, middle = sizes, inner = rates
for RUN in $(seq 1 "$NUM_RUNS"); do
  echo "=========================================="
  echo "Run $RUN of $NUM_RUNS"
  echo "=========================================="
  echo ""

  for SIZE in "${SIZE_ARRAY[@]}"; do
    echo "=========================================="
    echo "Run $RUN/$NUM_RUNS — message size: $SIZE bytes"
    echo "=========================================="

    SIZE_CSV="$TEMP_DIR/size_${SIZE}.csv"

    # Determine rate limits for this size (per-size override or global fallback)
    RATES_STR="${SIZE_RATE_MAP[$SIZE]:-$RATE_LIMITS}"
    IFS=',' read -ra RATES_THIS_SIZE <<< "$RATES_STR"

    # Run test for each rate limit
    for RATE in "${RATES_THIS_SIZE[@]}"; do
      echo "--------------------------------------"
      echo "Run $RUN/$NUM_RUNS — size: $SIZE bytes, rate: $RATE msgs/s"
      echo "--------------------------------------"
      
      # Purge the queue before test using HTTP API
      echo "Purging queue '$QUEUE_NAME' via HTTP API..."
      PURGE_RESPONSE=$(curl -s -w "\n%{http_code}" --request DELETE \
        --url "http://$BROKER_IP:15672/api/queues/%2F/$QUEUE_NAME/contents" \
        --header 'Accept: application/json' \
        --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=' 2>&1)
      
      HTTP_CODE=$(echo "$PURGE_RESPONSE" | tail -n1)
      if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
        echo "Queue purged successfully"
      else
        echo "Warning: Queue purge returned HTTP $HTTP_CODE (queue may not exist yet or already empty)"
      fi
      
      # Run the latency test
      echo "Running latency test (size=$SIZE, rate=$RATE, duration=$DURATION seconds)..."
      TEST_OUTPUT=$(lavinmqperf throughput -z "$DURATION" -x 1 -y 1 -s "$SIZE" -r "$RATE" --measure-latency \
        --uri="amqp://perftest:perftest@$BROKER_IP?tcp_nodelay=true" 2>&1)
      
      # Display the output
      echo "$TEST_OUTPUT"
      
      # Extract only the Summary section (everything after "Summary:")
      SUMMARY=$(echo "$TEST_OUTPUT" | sed -n '/^Summary:/,$p')
      
      # Parse latency results from Summary section (already in milliseconds)
      MIN_MS=$(echo "$SUMMARY" | grep -E "^\s+min:\s+" | awk '{print $2}')
      MEDIAN_MS=$(echo "$SUMMARY" | grep -E "^\s+median:\s+" | awk '{print $2}')
      P75_MS=$(echo "$SUMMARY" | grep -E "^\s+75th:\s+" | awk '{print $2}')
      P95_MS=$(echo "$SUMMARY" | grep -E "^\s+95th:\s+" | awk '{print $2}')
      P99_MS=$(echo "$SUMMARY" | grep -E "^\s+99th:\s+" | awk '{print $2}')
      
      # Parse average throughput from Summary section for bandwidth calculation
      PUB_RATE=$(echo "$SUMMARY" | grep "Average publish rate:" | awk '{print $4}')
      CON_RATE=$(echo "$SUMMARY" | grep "Average consume rate:" | awk '{print $4}')
      
      if [ -z "$MIN_MS" ] || [ -z "$MEDIAN_MS" ] || [ -z "$PUB_RATE" ]; then
        echo "Error: Failed to parse test results for size $SIZE, rate $RATE (run $RUN)"
        echo "MIN_MS=$MIN_MS, MEDIAN_MS=$MEDIAN_MS, PUB_RATE=$PUB_RATE"
        exit 1
      fi
      
      # Format latency values to 2 decimal places
      MIN_MS=$(printf "%.2f" "$MIN_MS")
      MEDIAN_MS=$(printf "%.2f" "$MEDIAN_MS")
      P75_MS=$(printf "%.2f" "$P75_MS")
      P95_MS=$(printf "%.2f" "$P95_MS")
      P99_MS=$(printf "%.2f" "$P99_MS")

      # Calculate bandwidth in MiB/s and format to 2 decimal places
      PUB_BW=$(echo "scale=2; ($SIZE * $PUB_RATE) / (1024 * 1024)" | bc)
      CON_BW=$(echo "scale=2; ($SIZE * $CON_RATE) / (1024 * 1024)" | bc)
      
      # Ensure leading zero for values < 1.0
      [[ "$PUB_BW" =~ ^\. ]] && PUB_BW="0$PUB_BW"
      [[ "$CON_BW" =~ ^\. ]] && CON_BW="0$CON_BW"

      # Format bandwidth to exactly 2 decimal places
      PUB_BW=$(printf "%.2f" "$PUB_BW")
      CON_BW=$(printf "%.2f" "$CON_BW")
      
      echo "Results: Latency min/median/p75/p95/p99: ${MIN_MS}/${MEDIAN_MS}/${P75_MS}/${P95_MS}/${P99_MS} ms"
      echo "         Publish rate: $PUB_RATE msgs/s"
      echo "         Bandwidth: Publish=$PUB_BW MiB/s, Consume=$CON_BW MiB/s"
      echo ""
      
      # Append to CSV: Run,RateLimit,Min,Median,P75,P95,P99,PubRate,PubBW,ConBW
      echo "$RUN,$RATE,$MIN_MS,$MEDIAN_MS,$P75_MS,$P95_MS,$P99_MS,$PUB_RATE,$PUB_BW,$CON_BW" >> "$SIZE_CSV"
    done

    echo ""
  done
done

echo "=========================================="
echo "All tests completed!"
echo "=========================================="
echo ""

# Generate markdown report
echo "Generating markdown summary..."

{
  echo "# $BROKER_INSTANCE_TYPE"
  echo ""
  echo "## Test Configuration"
  echo ""
  echo "- Duration: $DURATION seconds (\`-z $DURATION\`)"
  echo "- Producers: 1 (\`-x 1\`)"
  echo "- Consumers: 1 (\`-y 1\`)"
  echo "- Runs per combination: $NUM_RUNS"
  echo "- Message sizes: $SIZES bytes"
  echo "- Rate limits: $RATE_LIMITS msgs/s"
  if [ -n "$PER_SIZE_RATE_LIMITS" ]; then
    echo "- Per-size rate limits override:"
    IFS='|' read -ra _PAIRS <<< "$PER_SIZE_RATE_LIMITS"
    for _PAIR in "${_PAIRS[@]}"; do
      echo "  - ${_PAIR%%:*} bytes: ${_PAIR#*:} msgs/s"
    done
  fi
  echo "- Queue: $QUEUE_NAME"
  echo "- Latency measurement: Enabled (\`--measure-latency\`)"
  echo ""
  echo "## Units"
  echo ""
  echo "- Rate limits: (msgs/s)"
  echo "- Latency [min, median, P75, P95, P99]: (ms)"
  echo "- Publish rate: (msgs/s)"
  echo "- Publish/consume bandwidth: (MiB/s)"
  echo ""

  # Generate a table for each message size
  for SIZE in "${SIZE_ARRAY[@]}"; do
    SIZE_CSV="$TEMP_DIR/size_${SIZE}.csv"

    echo "## Message Size: $SIZE bytes"
    echo ""

    if [ "$NUM_RUNS" -eq 1 ]; then
      echo "| Rate Limit |     Min |  Median |     P75 |     P95 |      P99 | Pub. Rate |  Pub. BW |  Con. BW |"
      echo "|-----------:|--------:|--------:|--------:|--------:|---------:|----------:|---------:|---------:|"

      # Read CSV and format as markdown table (skip header row, skip Run column)
      tail -n +2 "$SIZE_CSV" | while IFS=',' read -r run rate min_lat median_lat p75_lat p95_lat p99_lat pub_rate pub_bw con_bw; do
        formatted_rate=$(format_number "$rate")
        formatted_pub_rate=$(format_number "$pub_rate")
        [[ "$pub_bw" =~ ^\. ]] && pub_bw="0$pub_bw"
        [[ "$con_bw" =~ ^\. ]] && con_bw="0$con_bw"
        printf "| %10s | %7s | %7s | %7s | %7s | %8s | %9s | %8s | %8s |\n" \
          "$formatted_rate" "$min_lat" "$median_lat" "$p75_lat" "$p95_lat" "$p99_lat" "$formatted_pub_rate" "$pub_bw" "$con_bw"
      done
    else
      # Per-run tables
      for RUN in $(seq 1 "$NUM_RUNS"); do
        echo "### Run $RUN of $NUM_RUNS ($SIZE)"
        echo ""
        echo "| Rate Limit |     Min |  Median |     P75 |     P95 |      P99 | Pub. Rate |  Pub. BW |  Con. BW |"
        echo "|-----------:|--------:|--------:|--------:|--------:|---------:|----------:|---------:|---------:|"

        awk -F',' -v run="$RUN" '$1 == run' "$SIZE_CSV" | while IFS=',' read -r run rate min_lat median_lat p75_lat p95_lat p99_lat pub_rate pub_bw con_bw; do
          formatted_rate=$(format_number "$rate")
          formatted_pub_rate=$(format_number "$pub_rate")
          [[ "$pub_bw" =~ ^\. ]] && pub_bw="0$pub_bw"
          [[ "$con_bw" =~ ^\. ]] && con_bw="0$con_bw"
          printf "| %10s | %7s | %7s | %7s | %7s | %8s | %9s | %8s | %8s |\n" \
            "$formatted_rate" "$min_lat" "$median_lat" "$p75_lat" "$p95_lat" "$p99_lat" "$formatted_pub_rate" "$pub_bw" "$con_bw"
        done
        echo ""
      done

      # Summary table (median across runs per rate — robust against single-run spikes)
      echo "### Summary ($NUM_RUNS runs, $SIZE)"
      echo ""
      echo "| Rate Limit |     Min |  Median |     P75 |     P95 |      P99 | Pub. Rate |  Pub. BW |  Con. BW |"
      echo "|-----------:|--------:|--------:|--------:|--------:|---------:|----------:|---------:|---------:|"

      RATES_STR="${SIZE_RATE_MAP[$SIZE]:-$RATE_LIMITS}"
      IFS=',' read -ra RATES_THIS_SIZE <<< "$RATES_STR"
      for RATE in "${RATES_THIS_SIZE[@]}"; do
        MED_MIN=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$3} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_MEDIAN=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$4} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_P75=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$5} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_P95=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$6} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_P99=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$7} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_PUB_RATE=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$8} END {asort(vals); m=int(n/2)+1; printf "%d", vals[m]}' "$SIZE_CSV")
        MED_PUB_BW=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$9} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")
        MED_CON_BW=$(awk -F',' -v r="$RATE" '$2 == r {vals[++n]=$10} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$SIZE_CSV")

        formatted_rate=$(format_number "$RATE")
        formatted_pub_rate=$(format_number "$MED_PUB_RATE")
        [[ "$MED_PUB_BW" =~ ^\. ]] && MED_PUB_BW="0$MED_PUB_BW"
        [[ "$MED_CON_BW" =~ ^\. ]] && MED_CON_BW="0$MED_CON_BW"
        printf "| %10s | %7s | %7s | %7s | %7s | %8s | %9s | %8s | %8s |\n" \
          "$formatted_rate" "$MED_MIN" "$MED_MEDIAN" "$MED_P75" "$MED_P95" "$MED_P99" "$formatted_pub_rate" "$MED_PUB_BW" "$MED_CON_BW"
      done
    fi

    echo ""
  done

} > "$OUTPUT_FILE"

echo "Results saved to: $OUTPUT_FILE"
echo ""
echo "=========================================="
echo "Summary:"
echo "=========================================="
cat "$OUTPUT_FILE"
echo "=========================================="

# Cleanup temp files
rm -rf "$TEMP_DIR"

exit 0
