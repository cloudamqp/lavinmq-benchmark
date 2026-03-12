# LavinMQ Throughput Test Results

Test Date: 2026-03-10 17:21:21 UTC
Broker Instance Type: z1d.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           668,400 |           668,395 |       10.19 |       10.19 |
|    64 |           682,960 |           682,878 |       41.68 |       41.67 |
|   256 |           246,253 |           246,177 |       60.12 |       60.10 |
|   512 |           128,073 |           128,024 |       62.53 |       62.51 |
|  1024 |            65,763 |            65,741 |       64.22 |       64.20 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
