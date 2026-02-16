# LavinMQ Latency Results

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.6.0.

Command:

```shell
lavinmqperf throughput -z 120 -x 1 -y 1 -s <size> --measure-latency
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 552,100 msgs/s    | 551,732 msgs/s    | 3.90     | 38.62       | 45.43    | 69.53    | 78.51    |
| 64                   | 506,949 msgs/s    | 506,821 msgs/s    | 2.87     | 34.36       | 37.62    | 44.25    | 52.63    |
| 256                  | 384,974 msgs/s    | 384,878 msgs/s    | 2.01     | 23.65       | 26.58    | 31.08    | 36.56    |
| 512                  | 286,181 msgs/s    | 286,127 msgs/s    | 4.22     | 13.93       | 16.71    | 22.48    | 27.26    |
| 1024                 | 198,740 msgs/s    | 198,695 msgs/s    | 2.38     | 22.82       | 26.83    | 32.14    | 38.22    |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 556,678 msgs/s    | 556,516 msgs/s    | 7.18     | 26.39       | 31.25    | 39.40    | 54.73    |
| 64                   | 506,319 msgs/s    | 506,111 msgs/s    | 2.12     | 46.72       | 49.45    | 53.46    | 63.23    |
| 256                  | 376,430 msgs/s    | 376,378 msgs/s    | 1.08     | 17.10       | 18.68    | 22.01    | 30.28    |
| 512                  | 279,332 msgs/s    | 279,287 msgs/s    | 1.61     | 18.78       | 21.31    | 24.88    | 27.76    |
| 1024                 | 187,997 msgs/s    | 187,952 msgs/s    | 1.16     | 22.82       | 26.51    | 30.63    | 32.67    |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 555,840 msgs/s    | 555,696 msgs/s    | 7.38     | 25.90       | 28.90    | 37.81    | 52.65    |
| 64                   | 506,168 msgs/s    | 505,987 msgs/s    | 5.50     | 44.16       | 46.69    | 52.90    | 62.08    |
| 256                  | 387,630 msgs/s    | 387,472 msgs/s    | 1.90     | 50.72       | 53.19    | 57.06    | 63.69    |
| 512                  | 290,576 msgs/s    | 290,519 msgs/s    | 1.19     | 21.29       | 23.72    | 27.31    | 32.12    |
| 1024                 | 196,683 msgs/s    | 196,618 msgs/s    | 1.72     | 22.82       | 28.13    | 36.64    | 40.77    |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 840,987 msgs/s    | 840,733 msgs/s    | 2.39     | 38.55       | 41.32    | 62.16    | 75.19    |
| 64                   | 776,558 msgs/s    | 776,484 msgs/s    | 3.31     | 11.38       | 12.47    | 37.71    | 47.74    |
| 256                  | 596,809 msgs/s    | 596,771 msgs/s    | 1.07     | 7.91        | 9.03     | 26.89    | 36.72    |
| 512                  | 453,421 msgs/s    | 453,364 msgs/s    | 4.57     | 15.35       | 17.02    | 21.81    | 33.90    |
| 1024                 | 303,458 msgs/s    | 303,437 msgs/s    | 2.72     | 8.36        | 9.63     | 11.31    | 19.85    |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 866,224 msgs/s    | 866,049 msgs/s    | 4.97     | 24.45       | 27.11    | 47.61    | 61.70    |
| 64                   | 797,536 msgs/s    | 797,458 msgs/s    | 1.54     | 11.99       | 13.31    | 37.79    | 49.19    |
| 256                  | 641,474 msgs/s    | 641,424 msgs/s    | 2.21     | 8.97        | 10.42    | 33.50    | 40.08    |
| 512                  | 489,928 msgs/s    | 489,755 msgs/s    | 0.65     | 8.95        | 10.38    | 19.56    | 32.24    |
| 1024                 | 331,726 msgs/s    | 331,704 msgs/s    | 1.99     | 6.07        | 7.33     | 10.07    | 20.45    |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 867,754 msgs/s    | 867,635 msgs/s    | 4.91     | 14.80       | 16.54    | 42.07    | 55.32    |
| 64                   | 814,231 msgs/s    | 814,061 msgs/s    | 1.29     | 22.78       | 24.72    | 46.10    | 59.05    |
| 256                  | 644,725 msgs/s    | 644,671 msgs/s    | 0.73     | 8.79        | 10.24    | 32.78    | 39.49    |
| 512                  | 505,016 msgs/s    | 504,987 msgs/s    | 4.13     | 7.76        | 9.07     | 23.60    | 32.05    |
| 1024                 | 349,286 msgs/s    | 349,262 msgs/s    | 0.41     | 9.40        | 10.73    | 12.97    | 23.29    |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 1,015,080 msgs/s  | 1,014,844 msgs/s  | 0.78     | 30.60       | 34.89    | 66.73    | 76.21    |
| 64                   | 951,430 msgs/s    | 951,310 msgs/s    | 1.19     | 15.50       | 17.28    | 54.96    | 60.93    |
| 256                  | 773,559 msgs/s    | 773,485 msgs/s    | 0.38     | 8.96        | 12.65    | 46.64    | 51.85    |
| 512                  | 597,851 msgs/s    | 597,762 msgs/s    | 0.85     | 16.64       | 18.39    | 41.94    | 47.73    |
| 1024                 | 420,266 msgs/s    | 420,223 msgs/s    | 1.27     | 12.29       | 13.71    | 23.41    | 32.80    |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD 4th gen EPYC)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 682,518 msgs/s    | 682,516 msgs/s    | 0.21     | 0.34        | 0.38     | 21.45    | 50.64    |
| 64                   | 594,913 msgs/s    | 594,911 msgs/s    | 0.14     | 0.25        | 0.29     | 15.91    | 44.02    |
| 256                  | 521,845 msgs/s    | 521,833 msgs/s    | 0.14     | 0.31        | 1.46     | 11.63    | 37.32    |
| 512                  | 332,714 msgs/s    | 332,644 msgs/s    | 0.11     | 1.86        | 4.97     | 3722.67⚠️ | 4983.59⚠️ |
| 1024                 | 255,276 msgs/s    | 255,275 msgs/s    | 0.12     | 6.19        | 25.87    | 924.30⚠️  | 2455.94⚠️ |

⚠️ _Note: Elevated latency values at larger message sizes may indicate performance degradation or test anomalies._

### Storage Optimized

**i7i.large** - 2 vCPU, 16 GiB RAM (Intel Xeon 5th gen, local NVMe)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 1,087,424 msgs/s  | 1,087,406 msgs/s  | 0.23     | 7.91        | 40.54    | 87.50    | 98.07    |
| 64                   | 963,583 msgs/s    | 963,581 msgs/s    | 0.12     | 3.36        | 28.72    | 81.37    | 90.44    |
| 256                  | 784,875 msgs/s    | 784,680 msgs/s    | 0.12     | 5.36        | 14.13    | 69.68    | 82.51    |
| 512                  | 636,264 msgs/s    | 626,772 msgs/s    | 0.22     | 70.22       | 3003.59⚠️ | 3429.64⚠️ | 3469.85⚠️ |
| 1024                 | 395,053 msgs/s    | 395,039 msgs/s    | 0.42     | 3.87        | 6.78     | 36.23    | 50.48    |

⚠️ _Note: Size 512 shows anomalous latency spikes._

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 1,024,762 msgs/s  | 1,024,501 msgs/s  | 0.45     | 31.00       | 34.69    | 67.85    | 77.74    |

_Note: Data for message sizes 64, 256, 512, and 1024 bytes not available._

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (Intel Xeon Scalable)

| Message Size (bytes) | Avg. Publish Rate | Avg. Consume Rate | Min (ms) | Median (ms) | P75 (ms) | P95 (ms) | P99 (ms) |
| -------------------- | ----------------- | ----------------- | -------- | ----------- | -------- | -------- | -------- |
| 16                   | 664,409 msgs/s    | 664,406 msgs/s    | 0.36     | 0.97        | 8.75     | 63.00    | 74.99    |
| 64                   | 637,500 msgs/s    | 637,474 msgs/s    | 0.29     | 1.82        | 7.81     | 60.23    | 72.02    |
| 256                  | 230,511 msgs/s    | 230,439 msgs/s    | 0.26     | 14959.68⚠️   | 25823.07⚠️ | 39763.25⚠️ | 41257.36⚠️ |
| 512                  | 128,892 msgs/s    | 128,855 msgs/s    | 0.39     | 10.62       | 96.40    | 100.48   | 729.41   |
| 1024                 | 66,397 msgs/s     | 66,374 msgs/s     | 0.32     | 8.19        | 101.92   | 106.39   | 152.70   |

⚠️ _Note: Size 256 shows catastrophic latency degradation, indicating severe performance issues during test._
