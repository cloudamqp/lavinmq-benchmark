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

apt-get install -y git make

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# Use init + fetch instead of clone so that arbitrary commit SHAs work.
# A regular clone only fetches branch/tag tips; commits reachable only via
# PR refs or deleted branches won't be found with `git checkout`.
git -C "$WORK_DIR" init
git -C "$WORK_DIR" fetch --depth=1 "$REPO_URL" "$GIT_REF"
cd "$WORK_DIR"
git checkout FETCH_HEAD

case "$TARGET" in
  broker)
    make bin/lavinmq
    systemctl stop lavinmq.service
    install -m 755 bin/lavinmq /usr/bin/lavinmq
    systemctl start lavinmq.service
    ;;
  perf)
    make bin/lavinmqperf
    install -m 755 bin/lavinmqperf /usr/bin/lavinmqperf
    ;;
  *)
    echo "Unknown target: $TARGET (expected: broker or perf)" >&2
    exit 1
    ;;
esac
