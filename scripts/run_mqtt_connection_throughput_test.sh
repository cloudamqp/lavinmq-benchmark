#!/bin/bash

# Script to measure MQTT throughput at increasing connection levels
# Usage: ./run_mqtt_connection_throughput_test.sh <broker_ip> <connection_steps> <load_generator_count> <instance_index> <broker_instance_type> <publishers> <consumers> <message_size> <test_duration>

set -e

# Function to format numbers with thousand separators
format_number() {
  local num="$1"
  LC_NUMERIC=en_US.UTF-8 printf "%'d" "$num" 2>/dev/null || \
    echo "$num" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

BROKER_IP="${1}"
CONNECTION_STEPS="${2:-100,10000,100000,500000,1000000}"
LOAD_GENERATOR_COUNT="${3:-10}"
INSTANCE_INDEX="${4:-0}"
BROKER_INSTANCE_TYPE="${5:-unknown}"
PUBLISHERS="${6:-1}"
CONSUMERS="${7:-1}"
MESSAGE_SIZE="${8:-256}"
TEST_DURATION="${9:-60}"
OUTPUT_FILE="/home/ubuntu/mqtt_connection_throughput_results.md"
TEMP_CSV="/tmp/mqtt_connection_throughput_results.csv"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

MQTT_PORT=1883
USERNAME="perftest"
PASSWORD="perftest"
TOPIC="mqtt-conn-tp-test"
CONN_TOPIC="mqtt-conn-bg"
SETTLE_TIME=10

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  exit 1
fi

# Raise FD limits for this session
ulimit -n 1048576 2>/dev/null || ulimit -n $(ulimit -Hn) 2>/dev/null || true

# Raise Erlang VM port limit for emqtt-bench
export ERL_MAX_PORTS=1048576

# Discover all local private IPs (primary + secondary) for connection distribution
LOCAL_IPS=($(hostname -I))
NUM_LOCAL_IPS=${#LOCAL_IPS[@]}
echo "Local IPs available: ${LOCAL_IPS[*]} ($NUM_LOCAL_IPS total)"
MAX_CONNS_PER_IP=30000

# Fetch LavinMQ version from broker API
echo "Fetching LavinMQ version from broker..."
OVERVIEW_RESPONSE=$(curl -s --request GET \
  --url "http://$BROKER_IP:15672/api/overview" \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=')

LAVINMQ_VERSION=$(echo "$OVERVIEW_RESPONSE" | grep -o '"lavinmq_version":"[^"]*"' | cut -d'"' -f4)

if [ -z "$LAVINMQ_VERSION" ]; then
  LAVINMQ_VERSION="Unknown (failed to fetch)"
fi

echo "=========================================="
echo "MQTT Connection Throughput Test"
echo "=========================================="
echo "Broker IP: $BROKER_IP"
echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
echo "LavinMQ Version: $LAVINMQ_VERSION"
echo "Connection Steps: $CONNECTION_STEPS"
echo "Load Generators: $LOAD_GENERATOR_COUNT"
echo "Instance Index: $INSTANCE_INDEX"
echo "Publishers: $PUBLISHERS"
echo "Consumers: $CONSUMERS"
echo "Message Size: $MESSAGE_SIZE bytes"
echo "Test Duration: $TEST_DURATION seconds"
echo "=========================================="
echo ""

# Initialize CSV temp file
echo "Connections,Pub_Rate,Con_Rate,Pub_BW,Con_BW" > "$TEMP_CSV"

# Convert comma-separated steps to array
IFS=',' read -ra STEP_ARRAY <<< "$CONNECTION_STEPS"

for TARGET in "${STEP_ARRAY[@]}"; do
  # Calculate this instance's share of idle connections
  PER_INSTANCE=$((TARGET / LOAD_GENERATOR_COUNT))
  if [ "$INSTANCE_INDEX" -lt $((TARGET % LOAD_GENERATOR_COUNT)) ]; then
    PER_INSTANCE=$((PER_INSTANCE + 1))
  fi

  echo "--------------------------------------"
  echo "Testing throughput with $TARGET background connections ($PER_INSTANCE on this instance)"
  echo "--------------------------------------"

  # All instances establish their share of idle connections, distributed across local IPs
  BG_PIDS=()
  if [ "$PER_INSTANCE" -gt 0 ]; then
    REMAINING=$PER_INSTANCE
    IP_INDEX=0
    for LOCAL_IP in "${LOCAL_IPS[@]}"; do
      if [ "$REMAINING" -le 0 ]; then
        break
      fi
      CHUNK=$REMAINING
      if [ "$CHUNK" -gt "$MAX_CONNS_PER_IP" ]; then
        CHUNK=$MAX_CONNS_PER_IP
      fi
      echo "  Starting $CHUNK background connections on $LOCAL_IP..."
      emqtt_bench sub \
        -h "$BROKER_IP" -p "$MQTT_PORT" \
        -t "$CONN_TOPIC" \
        -c "$CHUNK" -i 1 -q 0 -V 4 \
        -u "$USERNAME" -P "$PASSWORD" \
        --ifaddr "$LOCAL_IP" \
        > /tmp/emqtt_bg_conn_ip${IP_INDEX}.log 2>&1 &
      BG_PIDS+=($!)
      REMAINING=$((REMAINING - CHUNK))
      IP_INDEX=$((IP_INDEX + 1))
    done
  fi

  # Wait for connections to establish
  # Broker acceptance rate drops under load from many instances, use conservative 200 conn/sec/IP
  WAIT_TIME=$(( PER_INSTANCE / (200 * NUM_LOCAL_IPS) + 30 ))
  if [ "$WAIT_TIME" -lt "$SETTLE_TIME" ]; then
    WAIT_TIME=$SETTLE_TIME
  fi
  echo "Waiting ${WAIT_TIME}s for connections to establish..."
  sleep "$WAIT_TIME"

  # Only instance 0 runs the throughput test and generates the report
  if [ "$INSTANCE_INDEX" -eq 0 ]; then
    # Query actual connection count
    CONN_RESPONSE=$(curl -s --request GET \
      --url "http://$BROKER_IP:15672/api/overview" \
      --header 'Accept: application/json' \
      --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=')
    # Connection count is under object_totals in the LavinMQ management API
    ACTUAL_CONNS=$(echo "$CONN_RESPONSE" | grep -o '"object_totals":{[^}]*}' | grep -o '"connections":[0-9]*' | grep -o '[0-9]*' || echo "0")
    echo "Actual connections before throughput test: $ACTUAL_CONNS"

    # Run throughput test using mqtt_bench.sh
    echo "Running throughput test (pub=$PUBLISHERS, con=$CONSUMERS, size=$MESSAGE_SIZE, duration=$TEST_DURATION)..."
    TEST_OUTPUT=$("$SCRIPT_DIR/mqtt_bench.sh" throughput -z "$TEST_DURATION" -x "$PUBLISHERS" -y "$CONSUMERS" -s "$MESSAGE_SIZE" \
      --uri="mqtt://$USERNAME:$PASSWORD@$BROKER_IP" 2>&1)

    echo "$TEST_OUTPUT"

    # Parse results
    PUB_RATE=$(echo "$TEST_OUTPUT" | grep "Average publish rate:" | awk '{print $4}')
    CON_RATE=$(echo "$TEST_OUTPUT" | grep "Average consume rate:" | awk '{print $4}')

    if [ -z "$PUB_RATE" ] || [ -z "$CON_RATE" ]; then
      echo "Warning: Failed to parse test results for $TARGET connections"
      PUB_RATE=0
      CON_RATE=0
    fi

    # Calculate bandwidth in MiB/s
    PUB_BW=$(echo "scale=2; ($MESSAGE_SIZE * $PUB_RATE) / (1024 * 1024)" | bc)
    CON_BW=$(echo "scale=2; ($MESSAGE_SIZE * $CON_RATE) / (1024 * 1024)" | bc)

    echo "Results: Publish=$PUB_RATE msgs/s ($PUB_BW MiB/s), Consume=$CON_RATE msgs/s ($CON_BW MiB/s)"

    echo "$ACTUAL_CONNS,$PUB_RATE,$CON_RATE,$PUB_BW,$CON_BW" >> "$TEMP_CSV"
  else
    # Non-zero instances hold connections during the throughput test
    echo "Instance $INSTANCE_INDEX: holding connections for ${TEST_DURATION}s..."
    sleep "$TEST_DURATION"
  fi

  # Clean up background connections
  for pid in "${BG_PIDS[@]}"; do
    pkill -9 -P "$pid" 2>/dev/null || true
    kill -9 "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
  done
  sleep 5

  echo ""
done

echo "=========================================="
echo "All steps completed!"
echo "=========================================="
echo ""

# Only instance 0 generates the report
if [ "$INSTANCE_INDEX" -ne 0 ]; then
  echo "Instance $INSTANCE_INDEX done. Report generated by instance 0."
  exit 0
fi

# Generate markdown report
echo "Generating markdown summary..."

{
  echo "# LavinMQ MQTT Connection Throughput Test Results"
  echo ""
  echo "Test Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
  echo "LavinMQ Version: $LAVINMQ_VERSION"
  echo ""
  echo "## Results"
  echo ""
  echo "- Protocol: MQTT v4"
  echo "- Size: $MESSAGE_SIZE bytes"
  echo "- Average publish/consume rates: (msgs/s)"
  echo "- Publish/Consume bandwidth: (MiB/s)"
  echo ""
  echo "| Connections | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |"
  echo "|------------:|------------------:|------------------:|------------:|------------:|"

  tail -n +2 "$TEMP_CSV" | while IFS=',' read -r conns pub_rate con_rate pub_bw con_bw; do
    formatted_conns=$(format_number "$conns")
    formatted_pub=$(format_number "$pub_rate")
    formatted_con=$(format_number "$con_rate")
    printf "| %11s | %17s | %17s | %11s | %11s |\n" "$formatted_conns" "$formatted_pub" "$formatted_con" "$pub_bw" "$con_bw"
  done

  echo ""
  echo "## Test Configuration"
  echo ""
  echo "- Protocol: MQTT v4"
  echo "- Duration: $TEST_DURATION seconds per step"
  echo "- Publishers: $PUBLISHERS (\`-x $PUBLISHERS\`)"
  echo "- Consumers: $CONSUMERS (\`-y $CONSUMERS\`)"
  echo "- Message size: $MESSAGE_SIZE bytes"
  echo "- Connection steps: $CONNECTION_STEPS"
  echo "- Load generators: $LOAD_GENERATOR_COUNT"
  echo ""
} > "$OUTPUT_FILE"

echo "Results saved to: $OUTPUT_FILE"
echo ""
echo "=========================================="
echo "Summary:"
echo "=========================================="
cat "$OUTPUT_FILE"
echo "=========================================="

rm -f "$TEMP_CSV"

exit 0
