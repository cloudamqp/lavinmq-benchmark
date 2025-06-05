#!/bin/bash -xe

apt-get update -qq > /dev/null

# Use lavinmq-prerelease repository for release candidates
if [[ -n "${LAVINMQ_VERSION}" && "${LAVINMQ_VERSION}" == *"-rc"* ]]; then
    REPO_NAME="lavinmq-prerelease"
else
    REPO_NAME="lavinmq"
fi

curl -fsSL https://packagecloud.io/cloudamqp/${REPO_NAME}/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/lavinmq.gpg > /dev/null
. /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/lavinmq.gpg] https://packagecloud.io/cloudamqp/${REPO_NAME}/$ID $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/lavinmq.list > /dev/null
apt-get update -qq > /dev/null

if [ -n "${LAVINMQ_VERSION}" ]
then apt-get install "lavinmq=${LAVINMQ_VERSION}-1" -y --allow-change-held-packages -qq --allow-downgrades > /dev/null
else apt-get install lavinmq -y --allow-change-held-packages -qq > /dev/null
fi

apt-get autoremove -y -qq > /dev/null
