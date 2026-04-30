# LavinMQ Throughput Test Results

Test Date: 2026-04-29 10:52:07 UTC
Broker Instance Type: c8g.large
LavinMQ Version: 2.7.0-rc.3

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           922,956 |           922,740 |       14.08 |       14.07 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Runs per size: 1
- Message sizes: 16 bytes
- Queue: perf-test

