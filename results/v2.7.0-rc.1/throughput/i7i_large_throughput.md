# LavinMQ Throughput Test Results

Test Date: 2026-03-10 17:37:22 UTC
Broker Instance Type: i7i.large
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           686,145 |           686,140 |       10.46 |       10.46 |
|    64 |           678,254 |           678,247 |       41.39 |       41.39 |
|   256 |           565,999 |           565,414 |      138.18 |      138.04 |
|   512 |           500,132 |           414,098 |      244.20 |      202.19 |
|  1024 |           357,113 |           356,914 |      348.74 |      348.54 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
    
