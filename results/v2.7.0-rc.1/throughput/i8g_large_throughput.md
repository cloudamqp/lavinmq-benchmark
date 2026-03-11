# LavinMQ Throughput Test Results

Test Date: 2026-03-10 17:05:40 UTC
Broker Instance Type: i8g.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           998,008 |           997,853 |       15.22 |       15.22 |
|    64 |           926,245 |           926,130 |       56.53 |       56.52 |
|   256 |           783,402 |           783,341 |      191.26 |      191.24 |
|   512 |           629,451 |           629,383 |      307.34 |      307.31 |
|  1024 |           433,451 |           433,419 |      423.29 |      423.26 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test

