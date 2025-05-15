#!/bin/bash -xe

apt-get update -qq > /dev/null 2>&1
curl -fsSL https://packagecloud.io/84codes/crystal/gpgkey | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/84codes_crystal.gpg > /dev/null
. /etc/os-release
echo "deb https://packagecloud.io/84codes/crystal/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/84codes_crystal.list > /dev/null
apt-get update -qq > /dev/null 2>&1
apt-get install crystal -y -qq > /dev/null
