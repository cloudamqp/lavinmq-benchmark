#!/bin/bash -xe

apt-get update -qq > /dev/null 2>&1
curl -fsSL https://packagecloud.io/cloudamqp/lavinmq/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/lavinmq.gpg > /dev/null
. /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/lavinmq.gpg] https://packagecloud.io/cloudamqp/lavinmq/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/lavinmq.list > /dev/null
apt-get update -qq > /dev/null 2>&1

if [ -n "${LAVINMQ_VERSION}" ]
then apt-get install "lavinmq=${LAVINMQ_VERSION}-1" -y --allow-change-held-packages -qq > /dev/null
else apt-get install lavinmq -y --allow-change-held-packages -qq > /dev/null
fi

apt-get autoremove -y -qq > /dev/null 2>&1
