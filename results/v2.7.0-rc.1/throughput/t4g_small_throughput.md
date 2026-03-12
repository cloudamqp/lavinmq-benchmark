# LavinMQ Throughput Test Results

Test Date: 2026-03-10 16:24:27 UTC
Broker Instance Type: t4g.small
LavinMQ Version: 2.7.0-rc.1

## Results

- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           563,778 |           563,629 |        8.60 |        8.60 |
|    64 |           534,667 |           534,554 |       32.63 |       32.62 |
|   256 |           404,368 |           404,316 |       98.72 |       98.70 |
|   512 |           271,240 |           271,193 |      132.44 |      132.41 |
|  1024 |           174,233 |           174,208 |      170.14 |      170.12 |

## Test Configuration

- Duration: 60 seconds (`-z 60`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
