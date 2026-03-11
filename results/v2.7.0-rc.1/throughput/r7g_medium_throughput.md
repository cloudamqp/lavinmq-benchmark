# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:42:10 UTC
Broker Instance Type: r7g.medium
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           812,294 |           812,092 |       12.39 |       12.39 |
|    64 |           754,716 |           754,577 |       46.06 |       46.05 |
|   256 |           591,595 |           591,542 |      144.43 |      144.41 |
|   512 |           454,631 |           454,601 |      221.98 |      221.97 |
|  1024 |           309,656 |           309,617 |      302.39 |      302.36 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test

