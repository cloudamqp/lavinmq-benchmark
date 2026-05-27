#!/bin/bash -xe
# Build LavinMQ from source and replace the installed binary.
#
# Usage: build_lavinmq.sh <repo_url> <git_ref> <target>
#   target: broker  – build lavinmq binary and restart the service
#           perf    – build lavinmqperf binary (service must already be stopped)
#
# The apt-installed package is expected to already be present so that the
# systemd service file, config directories, and system user are all in place.
# This script only replaces the binary.

REPO_URL=$1
GIT_REF=$2
TARGET=$3

apt-get install -y git

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

git clone "$REPO_URL" "$WORK_DIR"
cd "$WORK_DIR"
git checkout "$GIT_REF"

# Install the Crystal version required by this source tree (if specified),
# otherwise upgrade to the latest available from the configured apt repo.
if [ -f ".crystal-version" ]; then
  CRYSTAL_VERSION=$(cat .crystal-version)
  apt-get install -y "crystal=${CRYSTAL_VERSION}-1"
else
  apt-get install -y crystal
fi

shards install --without-development

case "$TARGET" in
  broker)
    shards build lavinmq --production --no-debug
    systemctl stop lavinmq.service
    install -m 755 bin/lavinmq /usr/bin/lavinmq
    systemctl start lavinmq.service
    ;;
  perf)
    shards build lavinmqperf --production --no-debug
    install -m 755 bin/lavinmqperf /usr/bin/lavinmqperf
    ;;
  *)
    echo "Unknown target: $TARGET (expected: broker or perf)" >&2
    exit 1
    ;;
esac
