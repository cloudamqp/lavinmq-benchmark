#!/bin/bash -xe

# apt-get update can transiently fail when a mirror is mid-sync.
# Retry up to 3 times with a short backoff before giving up.
apt_update_with_retry() {
  local attempts=3
  local delay=15
  for i in $(seq 1 $attempts); do
    apt-get update -qq > /dev/null && return 0
    echo "apt-get update failed (attempt $i/$attempts), retrying in ${delay}s..."
    sleep $delay
  done
  echo "apt-get update failed after $attempts attempts"
  return 1
}

apt_update_with_retry
curl -fsSL https://packagecloud.io/84codes/crystal/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/84codes_crystal.gpg > /dev/null
. /etc/os-release
echo "deb https://packagecloud.io/84codes/crystal/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/84codes_crystal.list > /dev/null
apt_update_with_retry
apt-get install crystal -y -qq > /dev/null
