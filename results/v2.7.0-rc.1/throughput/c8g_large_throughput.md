# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:06:05 UTC
Broker Instance Type: c8g.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           994,301 |           993,935 |       15.17 |       15.16 |
|    64 |           919,750 |           919,641 |       56.13 |       56.13 |
|   256 |           758,653 |           758,567 |      185.21 |      185.19 |
|   512 |           611,270 |           611,221 |      298.47 |      298.44 |
|  1024 |           412,536 |           412,497 |      402.86 |      402.82 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test

