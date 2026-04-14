#!/bin/bash -xe

apt-get update -qq > /dev/null

# Install Erlang 27 for emqtt-bench (Ubuntu default is too old)
apt-get install -y -qq software-properties-common > /dev/null
add-apt-repository -y ppa:rabbitmq/rabbitmq-erlang > /dev/null
apt-get update -qq > /dev/null
apt-get install -y -qq erlang > /dev/null

# Install Java for mqttloader
apt-get install default-jre unzip -y -qq > /dev/null

# Build emqtt-bench
TOOLS_DIR="/opt/mqtt-tools"
mkdir -p "$TOOLS_DIR"

cd "$TOOLS_DIR"
rm -rf emqtt-bench
git clone https://github.com/emqx/emqtt-bench.git
cd emqtt-bench
BUILD_WITHOUT_QUIC=1 make

# Download mqttloader
cd "$TOOLS_DIR"
MQTTLOADER_VERSION="0.8.6"
curl -sL "https://github.com/dist-sys/mqttloader/releases/download/v${MQTTLOADER_VERSION}/mqttloader-${MQTTLOADER_VERSION}.zip" -o mqttloader.zip
unzip -q mqttloader.zip
rm mqttloader.zip
chmod +x mqttloader/bin/mqttloader

# Create symlinks for easy access
ln -sf "$TOOLS_DIR/emqtt-bench/_build/emqtt_bench/rel/emqtt_bench/bin/emqtt_bench" /usr/local/bin/emqtt_bench
ln -sf "$TOOLS_DIR/mqttloader/bin/mqttloader" /usr/local/bin/mqttloader
