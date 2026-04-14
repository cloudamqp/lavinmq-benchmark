#!/bin/bash

# Script to test MQTT connections at a single target level
# Instance 0 = monitor (no connections, collects results from workers via SSH)
# Instances 1-N = workers (establish connections, write count to local file)
# Usage: ./run_mqtt_connection_test.sh <broker_ip> <target> <count> <index> <instance_type> <worker_ips>

set -e

BROKER_IP="${1}"
TARGET="${2:-1000000}"
LOAD_GENERATOR_COUNT="${3:-20}"
INSTANCE_INDEX="${4:-0}"
BROKER_INSTANCE_TYPE="${5:-unknown}"
WORKER_IPS="${6:-}"
OUTPUT_FILE="/home/ubuntu/mqtt_connection_results.md"

MQTT_PORT=1883
USERNAME="perftest"
PASSWORD="perftest"

if [ -z "$BROKER_IP" ]; then
  echo "Error: Broker IP not provided"
  exit 1
fi

# Raise FD limits
ulimit -n 1048576 2>/dev/null || ulimit -n $(ulimit -Hn) 2>/dev/null || true

# Fetch LavinMQ version
echo "Fetching LavinMQ version..."
for attempt in 1 2 3; do
  OVERVIEW_RESPONSE=$(curl -s --max-time 30 \
    --url "http://$BROKER_IP:15672/api/overview" \
    --header 'Accept: application/json' \
    --header 'Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=' || true)
  if [ -n "$OVERVIEW_RESPONSE" ]; then break; fi
  sleep 10
done
LAVINMQ_VERSION=$(echo "$OVERVIEW_RESPONSE" | grep -o '"lavinmq_version":"[^"]*"' | cut -d'"' -f4)
if [ -z "$LAVINMQ_VERSION" ]; then LAVINMQ_VERSION="Unknown"; fi

echo "=========================================="
echo "MQTT Connection Test — Instance $INSTANCE_INDEX"
echo "Broker: $BROKER_IP ($BROKER_INSTANCE_TYPE)"
echo "LavinMQ: $LAVINMQ_VERSION"
echo "Target: $TARGET total connections"
echo "=========================================="

if [ "$INSTANCE_INDEX" -eq 0 ]; then
  #############################################
  # INSTANCE 0: Monitor — collect from workers
  #############################################

  WORKER_COUNT=$((LOAD_GENERATOR_COUNT - 1))

  # Wait for all workers to finish connecting
  # Last worker stagger: (WORKER_COUNT-1) * 15 = up to 270s, plus ~120s to connect
  WAIT_TIME=$(( (WORKER_COUNT - 1) * 15 + 120 ))
  echo "Waiting ${WAIT_TIME}s for all workers to establish connections..."
  sleep "$WAIT_TIME"

  # Collect counts from each worker via SSH
  echo "Collecting connection counts from workers..."
  IFS=',' read -ra IP_ARRAY <<< "$WORKER_IPS"
  TOTAL_CONNECTED=0
  TOTAL_FAILED=0

  for i in $(seq 1 $((LOAD_GENERATOR_COUNT - 1))); do
    WORKER_IP="${IP_ARRAY[$i]}"
    echo -n "  Worker $i ($WORKER_IP): "

    # Read the worker's result file
    WORKER_CONNECTED=$(ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
      ubuntu@"$WORKER_IP" 'grep "^Connected:" /tmp/mqtt_connect_stdout.log 2>/dev/null | awk "{print \$2}"' 2>/dev/null || echo "0")
    WORKER_FAILED=$(ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
      ubuntu@"$WORKER_IP" 'grep "^Failed:" /tmp/mqtt_connect_stdout.log 2>/dev/null | awk "{print \$2}"' 2>/dev/null || echo "0")

    if [ -z "$WORKER_CONNECTED" ]; then WORKER_CONNECTED=0; fi
    if [ -z "$WORKER_FAILED" ]; then WORKER_FAILED=0; fi

    echo "connected=$WORKER_CONNECTED failed=$WORKER_FAILED"
    TOTAL_CONNECTED=$((TOTAL_CONNECTED + WORKER_CONNECTED))
    TOTAL_FAILED=$((TOTAL_FAILED + WORKER_FAILED))
  done

  echo ""
  echo "=========================================="
  echo "Total: $TOTAL_CONNECTED connected, $TOTAL_FAILED failed (target: $TARGET)"
  echo "=========================================="

  # Generate report
  {
    echo "# LavinMQ MQTT Connection Test Results"
    echo ""
    echo "Test Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
    echo "Broker Instance Type: $BROKER_INSTANCE_TYPE"
    echo "LavinMQ Version: $LAVINMQ_VERSION"
    echo ""
    echo "## Results"
    echo ""
    echo "- Protocol: MQTT v3.1.1"
    echo "- Target: $TARGET connections"
    echo "- Achieved: $TOTAL_CONNECTED connections"
    echo "- Failed: $TOTAL_FAILED"
    echo "- Load generators: $LOAD_GENERATOR_COUNT ($((LOAD_GENERATOR_COUNT - 1)) workers + 1 monitor)"
    echo ""
  } > "$OUTPUT_FILE"

  echo "Results saved to: $OUTPUT_FILE"
  cat "$OUTPUT_FILE"

  # Hold for 120s for manual inspection
  echo ""
  echo "Holding for 120s — check broker stats now:"
  echo "  ssh ubuntu@$BROKER_IP 'free -h && cat /proc/loadavg && ps -o rss,%cpu,%mem -p \$(pgrep lavinmq)'"
  sleep 120

else
  #############################################
  # WORKERS: Establish connections and hold
  #############################################

  # Build Go tool
  if [ ! -f /home/ubuntu/mqtt_connect ]; then
    echo "Building mqtt_connect tool..."
    cd /home/ubuntu && go build -o mqtt_connect mqtt_connect.go && cd -
  fi

  # Calculate this worker's share (instances 1..N-1)
  WORKER_COUNT=$((LOAD_GENERATOR_COUNT - 1))
  WORKER_INDEX=$((INSTANCE_INDEX - 1))
  PER_INSTANCE=$((TARGET / WORKER_COUNT))
  if [ "$WORKER_INDEX" -lt $((TARGET % WORKER_COUNT)) ]; then
    PER_INSTANCE=$((PER_INSTANCE + 1))
  fi

  # Stagger based on worker index (not instance index)
  STAGGER=$((WORKER_INDEX * 15))
  echo "Worker $WORKER_INDEX: $PER_INSTANCE connections, stagger ${STAGGER}s"
  sleep "$STAGGER"

  # Get local IPs and connect
  LOCAL_IPS=$(hostname -I | tr ' ' ',' | sed 's/,$//')
  echo "Starting $PER_INSTANCE connections across IPs: $LOCAL_IPS"
  /home/ubuntu/mqtt_connect "${BROKER_IP}:${MQTT_PORT}" "$PER_INSTANCE" "$LOCAL_IPS" "$USERNAME" "$PASSWORD" "inst${INSTANCE_INDEX}" \
    > /tmp/mqtt_connect_stdout.log 2>/tmp/mqtt_connect_stderr.log &
  CONNECT_PID=$!

  # Wait for Go program to finish connecting
  WAITED=0
  while [ "$WAITED" -lt 300 ]; do
    if grep -q "^Connected:" /tmp/mqtt_connect_stdout.log 2>/dev/null; then break; fi
    sleep 5
    WAITED=$((WAITED + 5))
  done

  CONNECTED=$(grep "^Connected:" /tmp/mqtt_connect_stdout.log 2>/dev/null | awk '{print $2}' || echo "0")
  FAILED=$(grep "^Failed:" /tmp/mqtt_connect_stdout.log 2>/dev/null | awk '{print $2}' || echo "0")
  echo "Connected: $CONNECTED, Failed: $FAILED"

  # Hold connections long enough for monitor to collect + inspection window
  # Monitor waits ~390s then collects (~60s) then holds 120s = ~570s after we started
  HOLD_TIME=$(( 390 - STAGGER + 300 ))
  if [ "$HOLD_TIME" -lt 300 ]; then HOLD_TIME=300; fi
  echo "Holding connections for ${HOLD_TIME}s..."
  sleep "$HOLD_TIME"

  # Clean up
  kill "$CONNECT_PID" 2>/dev/null || true
  wait "$CONNECT_PID" 2>/dev/null || true
fi

echo "Done."
exit 0
