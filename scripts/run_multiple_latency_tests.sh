#!/bin/bash

# Script to run multiple latency tests with different message sizes and rate limits
# Usage: ./run_multiple_latency_tests.sh <broker_ip> [size1,size2,...] [rate1,rate2,...] [duration] [broker_instance_type]

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
OUTPUT_FILE="/home/ubuntu/latency_results.md"
TEMP_DIR="/tmp/latency_test_$$"
QUEUE_NAME="perf-test"

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  echo "Usage: $0 <broker_ip> [size1,size2,...] [rate1,rate2,...] [duration] [broker_instance_type]"
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
echo "Test Duration: $DURATION seconds"
echo "Output File: $OUTPUT_FILE"
echo "=========================================="
echo ""

# Convert comma-separated values to arrays
IFS=',' read -ra SIZE_ARRAY <<< "$SIZES"
IFS=',' read -ra RATE_ARRAY <<< "$RATE_LIMITS"

# Run tests for each size
for SIZE in "${SIZE_ARRAY[@]}"; do
  echo "=========================================="
  echo "Testing message size: $SIZE bytes"
  echo "=========================================="
  
  # Initialize CSV for this size
  SIZE_CSV="$TEMP_DIR/size_${SIZE}.csv"
  echo "RateLimit,Min,Median,P75,P95,P99,PubBW,ConBW" > "$SIZE_CSV"
  
  # Run test for each rate limit
  for RATE in "${RATE_ARRAY[@]}"; do
    echo "--------------------------------------"
    echo "Testing with rate limit: $RATE msgs/s"
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
      --uri="amqp://perftest:perftest@$BROKER_IP" 2>&1)
    
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
      echo "Error: Failed to parse test results for size $SIZE, rate $RATE"
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
    echo "         Bandwidth: Publish=$PUB_BW MiB/s, Consume=$CON_BW MiB/s"
    echo ""
    
    # Append to CSV
    echo "$RATE,$MIN_MS,$MEDIAN_MS,$P75_MS,$P95_MS,$P99_MS,$PUB_BW,$CON_BW" >> "$SIZE_CSV"
  done
  
  echo ""
done

echo "=========================================="
echo "All tests completed!"
echo "=========================================="
echo ""

# Generate markdown report
echo "Generating markdown summary..."

{
  echo "# Test Configuration"
  echo ""
  echo "- Duration: $DURATION seconds (\`-z $DURATION\`)"
  echo "- Producers: 1 (\`-x 1\`)"
  echo "- Consumers: 1 (\`-y 1\`)"
  echo "- Message sizes: $SIZES bytes"
  echo "- Rate limits: $RATE_LIMITS msgs/s"
  echo "- Queue: $QUEUE_NAME"
  echo "- Latency measurement: Enabled (\`--measure-latency\`)"
  echo ""
  echo "## Units"
  echo ""
  echo "- Rate limits: (msgs/s)"
  echo "- Latency [min, median, P75, P95, P99]: (ms)"
  echo "- Publish/consume bandwidth: (MiB/s)"
  echo ""
  echo "# $BROKER_INSTANCE_TYPE"
  echo ""
  
  # Generate a table for each message size
  for SIZE in "${SIZE_ARRAY[@]}"; do
    SIZE_CSV="$TEMP_DIR/size_${SIZE}.csv"
    
    echo "## Message Size: $SIZE bytes"
    echo ""
    echo "| Rate Limit |     Min |  Median |     P75 |     P95 |      P99 |  Pub. BW |  Con. BW |"
    echo "|-----------:|--------:|--------:|--------:|--------:|---------:|---------:|---------:|"
    
    # Read CSV and format as markdown table (skip header)
    tail -n +2 "$SIZE_CSV" | while IFS=',' read -r rate min_lat median_lat p75_lat p95_lat p99_lat pub_bw con_bw; do
      formatted_rate=$(format_number "$rate")
      # Ensure leading zeros for bandwidth values
      [[ "$pub_bw" =~ ^\. ]] && pub_bw="0$pub_bw"
      [[ "$con_bw" =~ ^\. ]] && con_bw="0$con_bw"
      printf "| %10s | %7s | %7s | %7s | %7s | %8s | %8s | %8s |\n" \
        "$formatted_rate" "$min_lat" "$median_lat" "$p75_lat" "$p95_lat" "$p99_lat" "$pub_bw" "$con_bw"
    done
    
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
