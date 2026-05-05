#!/bin/bash -xe

# Retry a command up to N times with exponential backoff.
# Usage: retry <max_attempts> <command> [args...]
retry() {
  local max="$1"; shift
  local attempt=1
  until "$@"; do
    if [ "$attempt" -ge "$max" ]; then
      echo "ERROR: '$*' failed after $max attempts" >&2
      return 1
    fi
    local wait=$(( attempt * 15 ))
    echo "WARNING: '$*' failed (attempt $attempt/$max), retrying in ${wait}s..." >&2
    sleep "$wait"
    attempt=$(( attempt + 1 ))
  done
}

retry 5 apt-get update -qq > /dev/null

# Install Erlang for emqtt-bench (OTP 27+ required; use cloudamqp/erlang on packagecloud)
. /etc/os-release
mkdir -p /etc/apt/keyrings
retry 5 curl -fsSL https://packagecloud.io/cloudamqp/erlang/gpgkey \
  -o /tmp/cloudamqp-erlang.gpg.tmp
gpg --dearmor < /tmp/cloudamqp-erlang.gpg.tmp > /etc/apt/keyrings/cloudamqp-erlang.gpg
rm /tmp/cloudamqp-erlang.gpg.tmp
echo "deb [signed-by=/etc/apt/keyrings/cloudamqp-erlang.gpg] https://packagecloud.io/cloudamqp/erlang/${ID} ${VERSION_CODENAME} main" \
  > /etc/apt/sources.list.d/cloudamqp-erlang.list
retry 5 apt-get update -qq > /dev/null
retry 5 apt-get install -y -qq esl-erlang > /dev/null

# Install Java for mqttloader
retry 5 apt-get install default-jre unzip -y -qq > /dev/null

# Build emqtt-bench
TOOLS_DIR="/opt/mqtt-tools"
mkdir -p "$TOOLS_DIR"

cd "$TOOLS_DIR"
rm -rf emqtt-bench
retry 5 git clone https://github.com/emqx/emqtt-bench.git
cd emqtt-bench
BUILD_WITHOUT_QUIC=1 make

# Download mqttloader
cd "$TOOLS_DIR"
MQTTLOADER_VERSION="0.8.6"
retry 5 curl -fsSL --retry 3 --retry-delay 10 --retry-all-errors \
  "https://github.com/dist-sys/mqttloader/releases/download/v${MQTTLOADER_VERSION}/mqttloader-${MQTTLOADER_VERSION}.zip" \
  -o mqttloader.zip
unzip -q mqttloader.zip
rm mqttloader.zip
chmod +x mqttloader/bin/mqttloader

# Create symlinks for easy access
ln -sf "$TOOLS_DIR/emqtt-bench/_build/emqtt_bench/rel/emqtt_bench/bin/emqtt_bench" /usr/local/bin/emqtt_bench
ln -sf "$TOOLS_DIR/mqttloader/bin/mqttloader" /usr/local/bin/mqttloader
