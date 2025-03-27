#!/bin/bash

echo "Waiting on lavinmqperf being installed..."
tries=0
while [[ $tries -le 10 ]]
do
  echo "Try # $tries"
  sleep 5
  if lavinmqperf != "lavinmqperf: not found"
  then
    echo "lavinmqperf found"
    exit 0
  else
    sleep 25
    (( tries++ ))
  fi
done
echo "Failed to find lavinmqperf"
exit 1
