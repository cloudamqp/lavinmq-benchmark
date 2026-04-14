#!/usr/bin/env bash

# Interactive MQTT connection test
# Run this locally after 'terraform apply' provisions the infrastructure.
# Adds connections in steps, shows broker stats, prompts to continue.
#
# Usage: ./run_connection_test_interactive.sh <broker_dns> <worker_dns_list_file> <broker_private_ip>
# Example:
#   terraform output -json load_generator_public_dns | jq -r '.[]' > /tmp/workers.txt
#   ./run_connection_test_interactive.sh $(terraform output -raw broker_public_dns) /tmp/workers.txt <broker_private_ip>

set -e

BROKER_DNS="${1}"
WORKER_FILE="${2}"
BROKER_PRIVATE_IP="${3}"
STEP_SIZE="${4:-100000}"

SSH_OPTS="-o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR"

if [ -z "$BROKER_DNS" ] || [ -z "$WORKER_FILE" ] || [ -z "$BROKER_PRIVATE_IP" ]; then
  echo "Usage: $0 <broker_public_dns> <worker_dns_file> <broker_private_ip> [step_size]"
  echo ""
  echo "Setup:"
  echo "  cd scenarios/aws/mqtt_connections"
  echo "  terraform output -json load_generator_public_dns | python3 -c \"import sys,json; [print(x) for x in json.load(sys.stdin)]\" > /tmp/workers.txt"
  echo "  BROKER_IP=\$(ssh $SSH_OPTS ubuntu@\$(terraform output -raw broker_public_dns) 'hostname -I | awk \"{print \\$1}\"')"
  echo "  ../../../scripts/run_connection_test_interactive.sh \$(terraform output -raw broker_public_dns) /tmp/workers.txt \$BROKER_IP"
  exit 1
fi

# Read worker DNS names
WORKERS=()
while IFS= read -r line; do
  [ -n "$line" ] && WORKERS+=("$line")
done < "$WORKER_FILE"
WORKER_COUNT=${#WORKERS[@]}

echo "=========================================="
echo "Interactive MQTT Connection Test"
echo "=========================================="
echo "Broker: $BROKER_DNS (private: $BROKER_PRIVATE_IP)"
echo "Workers: $WORKER_COUNT"
echo "Step size: $STEP_SIZE connections per step"
echo "=========================================="
echo ""

TOTAL_TARGET=0
STEP=0

while true; do
  STEP=$((STEP + 1))
  TOTAL_TARGET=$((TOTAL_TARGET + STEP_SIZE))
  PER_WORKER=$((STEP_SIZE / WORKER_COUNT))
  REMAINDER=$((STEP_SIZE % WORKER_COUNT))

  echo "----------------------------------------------"
  echo "Step $STEP: Adding $STEP_SIZE connections (total target: $TOTAL_TARGET)"
  echo "  $PER_WORKER per worker ($WORKER_COUNT workers)"
  echo "----------------------------------------------"

  # Start connections on each worker (stagger by 2s)
  for i in "${!WORKERS[@]}"; do
    WORKER="${WORKERS[$i]}"
    CHUNK=$PER_WORKER
    if [ "$i" -lt "$REMAINDER" ]; then
      CHUNK=$((CHUNK + 1))
    fi

    # Get worker's local IPs
    LOCAL_IPS=$(ssh $SSH_OPTS ubuntu@"$WORKER" 'hostname -I | tr " " "," | sed "s/,$//"' 2>/dev/null)

    echo "  Worker $i ($WORKER): $CHUNK connections..."
    ssh $SSH_OPTS ubuntu@"$WORKER" "nohup /home/ubuntu/mqtt_connect ${BROKER_PRIVATE_IP}:1883 $CHUNK $LOCAL_IPS perftest perftest step${STEP}_w${i} > /tmp/mqtt_step${STEP}.log 2>&1 &" &

    # Small stagger
    sleep 1
  done

  # Wait for background SSH commands to finish dispatching
  wait

  echo ""
  echo "Waiting 60s for connections to establish..."
  sleep 60

  # Check worker results
  echo ""
  echo "Worker results for step $STEP:"
  STEP_CONNECTED=0
  STEP_FAILED=0
  for i in "${!WORKERS[@]}"; do
    WORKER="${WORKERS[$i]}"
    RESULT=$(ssh $SSH_OPTS ubuntu@"$WORKER" "cat /tmp/mqtt_step${STEP}.log 2>/dev/null | grep -E '^(Connected|Failed):'" 2>/dev/null || echo "pending")
    CONN=$(echo "$RESULT" | grep "^Connected:" | awk '{print $2}' || echo "0")
    FAIL=$(echo "$RESULT" | grep "^Failed:" | awk '{print $2}' || echo "0")
    if [ -z "$CONN" ]; then CONN=0; fi
    if [ -z "$FAIL" ]; then FAIL=0; fi
    STEP_CONNECTED=$((STEP_CONNECTED + CONN))
    STEP_FAILED=$((STEP_FAILED + FAIL))
    echo "  Worker $i: connected=$CONN failed=$FAIL"
  done

  echo ""
  echo "Step $STEP: $STEP_CONNECTED connected, $STEP_FAILED failed"

  # Query broker stats
  echo ""
  echo "=== Broker Stats ==="
  ssh $SSH_OPTS ubuntu@"$BROKER_DNS" 'echo "Memory:" && free -h | grep Mem && echo "Load:" && cat /proc/loadavg && echo "LavinMQ process:" && ps -o rss,%cpu,%mem,comm -p $(pgrep lavinmq) 2>/dev/null | tail -1 && echo "Connections:" && curl -s --max-time 10 http://localhost:15672/api/overview -H "Authorization: Basic cGVyZnRlc3Q6cGVyZnRlc3Q=" | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get(\"object_totals\",{}).get(\"connections\",\"API unavailable\"))" 2>/dev/null || echo "API unavailable"' 2>/dev/null
  echo "===================="

  echo ""
  read -p "Add another $STEP_SIZE connections? [y/n] " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Stopping. Connections will remain until workers are terminated."
    break
  fi
done

echo ""
echo "Test complete. Total target: $TOTAL_TARGET"
echo "To clean up: terraform destroy"
