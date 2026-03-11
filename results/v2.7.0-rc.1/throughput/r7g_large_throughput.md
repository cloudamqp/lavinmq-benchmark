# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:50:17 UTC
Broker Instance Type: r7g.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           828,836 |           828,678 |       12.64 |       12.64 |
|    64 |           772,277 |           772,162 |       47.13 |       47.12 |
|   256 |           641,313 |           641,261 |      156.57 |      156.55 |
|   512 |           492,037 |           492,012 |      240.25 |      240.24 |
|  1024 |           333,771 |           333,751 |      325.94 |      325.92 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test

