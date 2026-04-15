#!/bin/bash

# Script to run multiple throughput tests with different message sizes
# Usage: ./run_multiple_throughput_tests.sh <broker_ip> [size1,size2,size3,...] [duration] [broker_instance_type] [num_runs]

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
DURATION="${3:-120}"  # Default duration 120 seconds if not provided
BROKER_INSTANCE_TYPE="${4:-unknown}"  # Broker instance type for reporting
NUM_RUNS="${5:-${BENCHMARK_NUM_RUNS:-1}}"  # Number of runs per size, default 1
OUTPUT_FILE="/home/ubuntu/throughput_results.md"
TEMP_CSV="/tmp/throughput_results.csv"
QUEUE_NAME="perf-test"

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  echo "Usage: $0 <broker_ip> [size1,size2,size3,...] [duration] [broker_instance_type] [num_runs]"
  exit 1
fi

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
echo "Multiple Throughput Test Runner"
echo "=========================================="
echo "Broker IP: $BROKER_IP"
echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
echo "LavinMQ Version: $LAVINMQ_VERSION"
echo "Message Sizes: $SIZES"
echo "Test Duration: $DURATION seconds"
echo "Number of Runs: $NUM_RUNS"
echo "Output File: $OUTPUT_FILE"
echo "=========================================="
echo ""

# Initialize CSV temp file
echo "Run,Size,Pub_Rate,Con_Rate,Pub_BW,Con_BW" > "$TEMP_CSV"

# Convert comma-separated sizes to array
IFS=',' read -ra SIZE_ARRAY <<< "$SIZES"

# Run tests: outer loop = runs, inner loop = sizes
for RUN in $(seq 1 "$NUM_RUNS"); do
  echo "=========================================="
  echo "Run $RUN of $NUM_RUNS"
  echo "=========================================="
  echo ""

  for SIZE in "${SIZE_ARRAY[@]}"; do
    echo "--------------------------------------"
    echo "Run $RUN/$NUM_RUNS — message size: $SIZE bytes"
    echo "--------------------------------------"
    
    # Purge the queue before test using HTTP API
    echo "Purging queue '$QUEUE_NAME' via HTTP API..."
    PURGE_RESPONSE=$(curl -s -w "\n%{http_code}" --request DELETE \
      --url "http://$BROKER_IP:15672/api/queues/%2F/$QUEUE_NAME/contents" \
      --header 'Accept: application/json' \
      --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=' 2>&1) # perftest:perftest in base64
    
    HTTP_CODE=$(echo "$PURGE_RESPONSE" | tail -n1)
    if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
      echo "Queue purged successfully"
    else
      echo "Warning: Queue purge returned HTTP $HTTP_CODE (queue may not exist yet or already empty)"
    fi
    
    # Run the throughput test
    echo "Running throughput test (size=$SIZE, duration=$DURATION seconds)..."
    TEST_OUTPUT=$(lavinmqperf throughput -z "$DURATION" -x 1 -y 1 -s "$SIZE" \
      --uri="amqp://perftest:perftest@$BROKER_IP" 2>&1)
    
    # Display the output
    echo "$TEST_OUTPUT"
    
    # Parse the results
    PUB_RATE=$(echo "$TEST_OUTPUT" | grep "Average publish rate:" | awk '{print $4}')
    CON_RATE=$(echo "$TEST_OUTPUT" | grep "Average consume rate:" | awk '{print $4}')
    
    if [ -z "$PUB_RATE" ] || [ -z "$CON_RATE" ]; then
      echo "Error: Failed to parse test results for size $SIZE (run $RUN)"
      exit 1
    fi
    
    # Calculate bandwidth in MiB/s: (size_bytes * msgs_per_sec) / (1024 * 1024)
    PUB_BW=$(echo "scale=2; ($SIZE * $PUB_RATE) / (1024 * 1024)" | bc)
    CON_BW=$(echo "scale=2; ($SIZE * $CON_RATE) / (1024 * 1024)" | bc)

    echo "Results: Publish=$PUB_RATE msgs/s ($PUB_BW MiB/s), Consume=$CON_RATE msgs/s ($CON_BW MiB/s)"
    echo ""
    
    # Append to CSV: Run,Size,Pub_Rate,Con_Rate,Pub_BW,Con_BW
    echo "$RUN,$SIZE,$PUB_RATE,$CON_RATE,$PUB_BW,$CON_BW" >> "$TEMP_CSV"
  done
done

echo "=========================================="
echo "All tests completed!"
echo "=========================================="
echo ""

# Generate markdown table
echo "Generating markdown summary..."

{
  echo "# LavinMQ Throughput Test Results"
  echo ""
  echo "Test Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
  echo "LavinMQ Version: $LAVINMQ_VERSION"
  echo ""
  echo "## Results"
  echo ""
  echo "- Size: (bytes)"
  echo "- Average publish/consume rates: (msgs/s)"
  echo "- Publish/Consume bandwidth: (MiB/s)"
  echo ""

  if [ "$NUM_RUNS" -eq 1 ]; then
    # Single run: emit the same table format as before
    echo "|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |"
    echo "|------:|------------------:|------------------:|------------:|------------:|"
    tail -n +2 "$TEMP_CSV" | while IFS=',' read -r run size pub_rate con_rate pub_bw con_bw; do
      formatted_pub=$(format_number "$pub_rate")
      formatted_con=$(format_number "$con_rate")
      printf "| %5s | %17s | %17s | %11s | %11s |\n" "$size" "$formatted_pub" "$formatted_con" "$pub_bw" "$con_bw"
    done
  else
    # Multiple runs: one table per run, then a summary table
    for RUN in $(seq 1 "$NUM_RUNS"); do
      echo "### Run $RUN of $NUM_RUNS"
      echo ""
      echo "|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |"
      echo "|------:|------------------:|------------------:|------------:|------------:|"
      grep "^$RUN," "$TEMP_CSV" | while IFS=',' read -r run size pub_rate con_rate pub_bw con_bw; do
        formatted_pub=$(format_number "$pub_rate")
        formatted_con=$(format_number "$con_rate")
        printf "| %5s | %17s | %17s | %11s | %11s |\n" "$size" "$formatted_pub" "$formatted_con" "$pub_bw" "$con_bw"
      done
      echo ""
    done

    # Summary table: median publish and consume rate per size (robust against single-run spikes)
    echo "### Summary (${NUM_RUNS} runs)"
    echo ""
    echo "|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |"
    echo "|------:|------------------:|------------------:|------------:|------------:|"
    for SIZE in "${SIZE_ARRAY[@]}"; do
      MED_PUB=$(awk -F',' -v s="$SIZE" '$2 == s {vals[++n]=$3} END {asort(vals); m=int(n/2)+1; printf "%d", vals[m]}' "$TEMP_CSV")
      MED_CON=$(awk -F',' -v s="$SIZE" '$2 == s {vals[++n]=$4} END {asort(vals); m=int(n/2)+1; printf "%d", vals[m]}' "$TEMP_CSV")
      MED_PUB_BW=$(awk -F',' -v s="$SIZE" '$2 == s {vals[++n]=$5} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$TEMP_CSV")
      MED_CON_BW=$(awk -F',' -v s="$SIZE" '$2 == s {vals[++n]=$6} END {asort(vals); m=int(n/2)+1; printf "%.2f", vals[m]}' "$TEMP_CSV")

      printf "| %5s | %17s | %17s | %11s | %11s |\n" \
        "$SIZE" \
        "$(format_number "$MED_PUB")" \
        "$(format_number "$MED_CON")" \
        "$MED_PUB_BW" \
        "$MED_CON_BW"
    done
  fi

  echo ""
  echo "## Test Configuration"
  echo ""
  echo "- Duration: $DURATION seconds (\`-z $DURATION\`)"
  echo "- Producers: 1 (\`-x 1\`)"
  echo "- Consumers: 1 (\`-y 1\`)"
  echo "- Runs per size: $NUM_RUNS"
  echo "- Message sizes: $SIZES bytes"
  echo "- Queue: $QUEUE_NAME"
  echo ""
} > "$OUTPUT_FILE"

echo "Results saved to: $OUTPUT_FILE"
echo ""
echo "=========================================="
echo "Summary:"
echo "=========================================="
cat "$OUTPUT_FILE"
echo "=========================================="

# Cleanup temp file
rm -f "$TEMP_CSV"

exit 0
