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

# Wait for the broker HTTP API to become available
wait_for_broker() {
  local max_wait="${1:-120}"
  local waited=0
  echo "Waiting for broker to be available..."
  while ! curl -sf --max-time 3 \
    --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=' \
    "http://$BROKER_IP:15672/api/overview" > /dev/null; do
    if [ "$waited" -ge "$max_wait" ]; then
      echo "ERROR: Broker not available after ${max_wait}s, giving up"
      exit 1
    fi
    echo "Broker not ready, retrying in 5s... (${waited}s elapsed)"
    sleep 5
    waited=$((waited + 5))
  done
  echo "Broker is available"
}

BROKER_IP="${1}"
SIZES="${2:-16,64,256,512,1024}"  # Default sizes if not provided
DURATION="${3:-120}"  # Default duration 120 seconds if not provided
BROKER_INSTANCE_TYPE="${4:-unknown}"  # Broker instance type for reporting
NUM_RUNS="${5:-${BENCHMARK_NUM_RUNS:-1}}"  # Number of runs per size, default 1
OUTPUT_CSV="/home/ubuntu/throughput_results.csv"
OUTPUT_JSON="/home/ubuntu/throughput_results.json"
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
echo "Output CSV:  $OUTPUT_CSV"
echo "Output JSON: $OUTPUT_JSON"
echo "=========================================="
echo ""

# Initialize CSV temp file
echo "Run,Size,PubRate,ConRate,PubBW,ConBW" > "$TEMP_CSV"

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
    
    # Ensure broker is up before purging (it may have restarted after an OOM kill)
    wait_for_broker

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

# Move temp CSV to final output location
mv "$TEMP_CSV" "$OUTPUT_CSV"

echo "Results saved to: $OUTPUT_CSV"

# Write JSON config
echo "Writing JSON config..."

SIZES_JSON=$(printf '%s' "$SIZES" | tr ',' '\n' | awk 'BEGIN{printf "["} NR>1{printf ","} {printf "%s",$1} END{printf "]"}')

printf '{\n  "instance_type": "%s",\n  "lavinmq_version": "%s",\n  "duration": %s,\n  "producers": 1,\n  "consumers": 1,\n  "runs": %s,\n  "queue": "%s",\n  "sizes": %s\n}' \
  "$BROKER_INSTANCE_TYPE" \
  "$LAVINMQ_VERSION" \
  "$DURATION" \
  "$NUM_RUNS" \
  "$QUEUE_NAME" \
  "$SIZES_JSON" \
  > "$OUTPUT_JSON"

echo "Config saved to: $OUTPUT_JSON"
echo ""
echo "=========================================="
echo "Summary:"
echo "=========================================="
echo "CSV:  $OUTPUT_CSV"
echo "JSON: $OUTPUT_JSON"
echo "=========================================="

exit 0
