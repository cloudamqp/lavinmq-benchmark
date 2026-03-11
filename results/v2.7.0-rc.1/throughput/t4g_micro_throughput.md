# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:16:55 UTC
Broker Instance Type: t4g.micro
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           537,778 |           537,612 |        8.20 |        8.20 |
|    64 |           530,975 |           530,866 |       32.40 |       32.40 |
|   256 |           397,785 |           397,733 |       97.11 |       97.10 |
|   512 |           311,919 |           311,880 |      152.30 |      152.28 |
|  1024 |           212,186 |           212,167 |      207.21 |      207.19 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
