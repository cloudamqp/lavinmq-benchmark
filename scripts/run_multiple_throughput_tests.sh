#!/bin/bash

# Script to run multiple throughput tests with different message sizes
# Usage: ./run_multiple_throughput_tests.sh <broker_ip> [size1,size2,size3,...] [duration] [broker_instance_type]

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
OUTPUT_FILE="/home/ubuntu/throughput_results.md"
TEMP_CSV="/tmp/throughput_results.csv"
QUEUE_NAME="perf-test"

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  echo "Usage: $0 <broker_ip> [size1,size2,size3,...] [duration] [broker_instance_type]"
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
echo "Output File: $OUTPUT_FILE"
echo "=========================================="
echo ""

# Initialize CSV temp file
echo "Size,Pub_Rate,Con_Rate" > "$TEMP_CSV"

# Convert comma-separated sizes to array
IFS=',' read -ra SIZE_ARRAY <<< "$SIZES"

# Run test for each size
for SIZE in "${SIZE_ARRAY[@]}"; do
  echo "--------------------------------------"
  echo "Testing with message size: $SIZE bytes"
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
    echo "Error: Failed to parse test results for size $SIZE"
    exit 1
  fi
  
  echo "Results: Publish=$PUB_RATE msgs/s, Consume=$CON_RATE msgs/s"
  echo ""
  
  # Append to CSV
  echo "$SIZE,$PUB_RATE,$CON_RATE" >> "$TEMP_CSV"
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
  echo "| Size (bytes) | Avg. Pub. Rate (msgs/s) | Avg. Con. Rate (msgs/s) |"
  echo "|-------------:|------------------------:|------------------------:|"
  
  # Read CSV and format as markdown table (skip header)
  tail -n +2 "$TEMP_CSV" | while IFS=',' read -r size pub_rate con_rate; do
    formatted_pub=$(format_number "$pub_rate")
    formatted_con=$(format_number "$con_rate")
    printf "| %12s | %23s | %23s |\n" "$size" "$formatted_pub" "$formatted_con"
  done
  
  echo ""
  echo "## Test Configuration"
  echo ""
  echo "- Duration: $DURATION seconds (\`-z $DURATION\`)"
  echo "- Producers: 1 (`-x 1`)"
  echo "- Consumers: 1 (`-y 1`)"
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
