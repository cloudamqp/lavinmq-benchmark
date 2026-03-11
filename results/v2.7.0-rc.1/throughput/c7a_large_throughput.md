# LavinMQ Throughput Test Results

Test Date: 2026-03-11 10:49:23 UTC
Broker Instance Type: c7a.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           680,269 |           680,265 |       10.38 |       10.38 |
|    64 |           637,626 |           637,623 |       38.91 |       38.91 |
|   256 |           526,615 |           526,556 |      128.56 |      128.55 |
|   512 |           479,529 |           479,523 |      234.14 |      234.14 |
|  1024 |           339,114 |           339,081 |      331.16 |      331.13 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
