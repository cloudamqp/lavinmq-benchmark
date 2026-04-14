# LavinMQ MQTT Throughput Test Results

Test Date: 2026-04-14 08:01:46 UTC
Broker Instance Type: c8g.large
LavinMQ Version: 2.6.10

## Results

- Protocol: MQTT v3.1.1
- Size: (bytes)
- Average publish/consume rates: (msgs/s)
- Publish/Consume bandwidth: (MiB/s)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           232,865 |            93,482 |        3.55 |        1.42 |
|    64 |           192,628 |            96,282 |       11.75 |        5.87 |
|   256 |           212,758 |           106,382 |       51.94 |       25.97 |
|   512 |           257,936 |           128,947 |      125.94 |       62.96 |
|  1024 |           209,748 |           105,029 |      204.83 |      102.56 |

## Test Configuration

- Protocol: MQTT v3.1.1
- Duration: 120 seconds (`-z 120`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes

