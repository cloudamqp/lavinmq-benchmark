#!/bin/bash

# mqtt_bench.sh — Thin wrapper around emqtt-bench and mqttloader that mimics
# lavinmqperf output format so MQTT test scripts can follow the same patterns.
#
# Usage:
#   mqtt_bench.sh throughput -z <duration> -x <publishers> -y <consumers> -s <size> --uri=mqtt://user:pass@host
#   mqtt_bench.sh throughput -z <duration> -x <publishers> -y <consumers> -s <size> -r <rate> --measure-latency --uri=mqtt://user:pass@host

set -e

COMMAND=""
DURATION=120
PUBLISHERS=1
CONSUMERS=1
SIZE=256
RATE=0
MEASURE_LATENCY=false
BROKER_HOST=""
BROKER_PORT=1883
USERNAME=""
PASSWORD=""
TOPIC="mqtt-bench-test"

# Parse arguments to match lavinmqperf interface
parse_args() {
  COMMAND="$1"
  shift

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -z) DURATION="$2"; shift 2 ;;
      -x) PUBLISHERS="$2"; shift 2 ;;
      -y) CONSUMERS="$2"; shift 2 ;;
      -s) SIZE="$2"; shift 2 ;;
      -r) RATE="$2"; shift 2 ;;
      --measure-latency) MEASURE_LATENCY=true; shift ;;
      --uri=*)
        URI="${1#--uri=}"
        # Parse mqtt://user:pass@host or mqtt://user:pass@host:port
        URI_BODY="${URI#*://}"
        if [[ "$URI_BODY" == *"@"* ]]; then
          CREDENTIALS="${URI_BODY%%@*}"
          HOST_PART="${URI_BODY#*@}"
          USERNAME="${CREDENTIALS%%:*}"
          PASSWORD="${CREDENTIALS#*:}"
          # Strip query string if present
          HOST_PART="${HOST_PART%%\?*}"
          if [[ "$HOST_PART" == *":"* ]]; then
            BROKER_HOST="${HOST_PART%%:*}"
            BROKER_PORT="${HOST_PART#*:}"
          else
            BROKER_HOST="$HOST_PART"
          fi
        else
          HOST_PART="${URI_BODY%%\?*}"
          if [[ "$HOST_PART" == *":"* ]]; then
            BROKER_HOST="${HOST_PART%%:*}"
            BROKER_PORT="${HOST_PART#*:}"
          else
            BROKER_HOST="$HOST_PART"
          fi
        fi
        shift ;;
      *) shift ;;
    esac
  done

  if [ -z "$BROKER_HOST" ]; then
    echo "Error: --uri is required"
    exit 1
  fi
}

# Build auth flags for emqtt-bench
auth_flags() {
  if [ -n "$USERNAME" ]; then
    echo "-u $USERNAME -P $PASSWORD"
  fi
}

# Run throughput test using emqtt-bench, output in lavinmqperf format
run_throughput() {
  local tmpdir
  tmpdir=$(mktemp -d)
  local auth
  auth="$(auth_flags)"

  # Start subscriber(s)
  if [ "$CONSUMERS" -gt 0 ]; then
    emqtt_bench sub \
      -h "$BROKER_HOST" -p "$BROKER_PORT" \
      -t "$TOPIC" \
      -c "$CONSUMERS" -q 0 -V 4 $auth \
      > "$tmpdir/sub.log" 2>&1 &
    SUB_PID=$!
    sleep 5
  fi

  # Start publishers
  emqtt_bench pub \
    -h "$BROKER_HOST" -p "$BROKER_PORT" \
    -t "$TOPIC" \
    -c "$PUBLISHERS" -s "$SIZE" -q 0 -I 0 -V 4 $auth \
    > "$tmpdir/pub.log" 2>&1 &
  PUB_PID=$!

  sleep "$DURATION"

  # Stop processes
  for pid in ${PUB_PID:-} ${SUB_PID:-}; do
    pkill -9 -P "$pid" 2>/dev/null || true
    kill -9 "$pid" 2>/dev/null || true
  done
  wait $PUB_PID ${SUB_PID:-} 2>/dev/null || true
  sleep 1

  # Parse peak rates from emqtt-bench output
  local pub_rate sub_rate
  pub_rate=$(tr '\r' '\n' < "$tmpdir/pub.log" \
    | sed -n 's/.*[0-9]s pub total=[0-9]* rate=\([0-9]*\)\..*/\1/p' \
    | sort -rn | head -1)
  pub_rate="${pub_rate:-0}"

  if [ "$CONSUMERS" -gt 0 ]; then
    sub_rate=$(tr '\r' '\n' < "$tmpdir/sub.log" \
      | sed -n 's/.*[0-9]s recv total=[0-9]* rate=\([0-9]*\)\..*/\1/p' \
      | sort -rn | head -1)
    sub_rate="${sub_rate:-0}"
  else
    sub_rate=0
  fi

  # Output in lavinmqperf format
  echo "Average publish rate: $pub_rate"
  echo "Average consume rate: $sub_rate"

  rm -rf "$tmpdir"
}

# Run latency test using mqttloader, output in lavinmqperf format
run_latency() {
  local tmpdir
  tmpdir=$(mktemp -d)

  # Calculate interval in microseconds from rate
  local interval_us=0
  if [ "$RATE" -gt 0 ]; then
    interval_us=$((1000000 / RATE))
  fi

  # Calculate num_messages from rate and duration
  local num_messages
  if [ "$RATE" -gt 0 ]; then
    num_messages=$((RATE * DURATION))
  else
    num_messages=1000000
  fi

  # Write mqttloader config
  cat > "$tmpdir/mqttloader.conf" <<EOF
broker = $BROKER_HOST
broker_port = $BROKER_PORT
mqtt_version = 3
num_publishers = $PUBLISHERS
num_subscribers = $CONSUMERS
qos_publisher = 1
qos_subscriber = 1
payload = $SIZE
interval = $interval_us
num_messages = $num_messages
exec_time = $DURATION
topic = $TOPIC
output = $tmpdir
EOF

  if [ -n "$USERNAME" ]; then
    echo "user_name = $USERNAME" >> "$tmpdir/mqttloader.conf"
    echo "password = $PASSWORD" >> "$tmpdir/mqttloader.conf"
  fi

  # Run mqttloader
  local ml_output
  ml_output=$(mqttloader -c "$tmpdir/mqttloader.conf" 2>&1) || true

  # Parse throughput from mqttloader stdout
  local pub_rate sub_rate
  pub_rate=$(echo "$ml_output" | grep "Average throughput" | head -1 | grep -o '[0-9,.]*' | head -1 | tr -d ',')
  sub_rate=$(echo "$ml_output" | grep "Average throughput" | tail -1 | grep -o '[0-9,.]*' | head -1 | tr -d ',')
  pub_rate="${pub_rate%%.*}"
  sub_rate="${sub_rate%%.*}"
  pub_rate="${pub_rate:-0}"
  sub_rate="${sub_rate:-0}"

  # Compute latency percentiles from mqttloader CSV
  local csv_file
  csv_file="$(find "$tmpdir" -name 'mqttloader_*.csv' | head -1)"

  local min_ms=0 median_ms=0 p75_ms=0 p95_ms=0 p99_ms=0
  if [ -n "$csv_file" ] && [ -s "$csv_file" ]; then
    # Extract receive latencies (us), convert to ms, sort, compute percentiles
    local stats
    stats=$(awk -F',' '$3 == "R" && $4 > 0 {printf "%.4f\n", $4 / 1000.0}' "$csv_file" \
      | sort -n \
      | awk '{vals[NR]=$1; sum+=$1}
        END {
          if (NR == 0) { print "0 0 0 0 0"; exit }
          printf "%.2f %.2f %.2f %.2f %.2f\n",
            vals[1], vals[int(NR*0.50)], vals[int(NR*0.75)], vals[int(NR*0.95)], vals[int(NR*0.99)]
        }')
    read -r min_ms median_ms p75_ms p95_ms p99_ms <<< "$stats"
  fi

  # Output in lavinmqperf format
  echo "Summary:"
  echo "  min: $min_ms"
  echo "  median: $median_ms"
  echo "  75th: $p75_ms"
  echo "  95th: $p95_ms"
  echo "  99th: $p99_ms"
  echo "Average publish rate: $pub_rate"
  echo "Average consume rate: $sub_rate"

  rm -rf "$tmpdir"
}

# Main
parse_args "$@"

if [ "$COMMAND" != "throughput" ]; then
  echo "Error: Unknown command '$COMMAND'. Only 'throughput' is supported."
  exit 1
fi

if [ "$MEASURE_LATENCY" = true ]; then
  run_latency
else
  run_throughput
fi
