# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:57:57 UTC
Broker Instance Type: r7g.xlarge
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           845,488 |           845,350 |       12.90 |       12.89 |
|    64 |           795,936 |           795,808 |       48.58 |       48.57 |
|   256 |           645,991 |           645,936 |      157.71 |      157.69 |
|   512 |           504,623 |           504,593 |      246.39 |      246.38 |
|  1024 |           370,190 |           370,167 |      361.51 |      361.49 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
