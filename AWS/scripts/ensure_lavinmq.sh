#!/bin/bash

echo "Waiting on lavinmq to be running..."
tries=0
while [[ $tries -le 10 ]]
do
  echo "Try # $tries"
  sleep 5
  STATUS="$(systemctl is-active lavinmq.service)"
  if [ "${STATUS}" = "active" ]; then
    echo "lavinmq is running"
    exit 0
  else
    sleep 25
    (( tries++ ))
  fi
done
echo "All number of tries reached"
exit 1
