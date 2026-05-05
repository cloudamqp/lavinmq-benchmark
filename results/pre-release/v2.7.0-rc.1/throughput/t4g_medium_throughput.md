# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:31:28 UTC
Broker Instance Type: t4g.medium
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           565,900 |           565,727 |        8.63 |        8.63 |
|    64 |           516,107 |           515,947 |       31.50 |       31.49 |
|   256 |           394,468 |           394,422 |       96.30 |       96.29 |
|   512 |           294,653 |           294,619 |      143.87 |      143.85 |
|  1024 |           199,357 |           199,324 |      194.68 |      194.65 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
