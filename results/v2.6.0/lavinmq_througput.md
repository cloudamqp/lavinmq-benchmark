# LavinMQ Latency Results

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Message Size**: Message size in bytes
- **Avg. Publish Rate**: Average publish rate in msgs/s
- **Avg. Consume Rate**: Average consume rate in msgs/s
- **Latency (ms)**: Contains Min, Median, P75, P95, P99 percentile values

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.6.0.

Command:

```shell
lavinmqperf throughput -z 120 -x 1 -y 1 -s <size> --measure-latency
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 552,100           | 551,732           | 3.90 | 38.62  | 45.43 | 69.53 | 78.51 |
| 64           | 506,949           | 506,821           | 2.87 | 34.36  | 37.62 | 44.25 | 52.63 |
| 256          | 384,974           | 384,878           | 2.01 | 23.65  | 26.58 | 31.08 | 36.56 |
| 512          | 286,181           | 286,127           | 4.22 | 13.93  | 16.71 | 22.48 | 27.26 |
| 1024         | 198,740           | 198,695           | 2.38 | 22.82  | 26.83 | 32.14 | 38.22 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 556,678           | 556,516           | 7.18 | 26.39  | 31.25 | 39.40 | 54.73 |
| 64           | 506,319           | 506,111           | 2.12 | 46.72  | 49.45 | 53.46 | 63.23 |
| 256          | 376,430           | 376,378           | 1.08 | 17.10  | 18.68 | 22.01 | 30.28 |
| 512          | 279,332           | 279,287           | 1.61 | 18.78  | 21.31 | 24.88 | 27.76 |
| 1024         | 187,997           | 187,952           | 1.16 | 22.82  | 26.51 | 30.63 | 32.67 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 555,840           | 555,696           | 7.38 | 25.90  | 28.90 | 37.81 | 52.65 |
| 64           | 506,168           | 505,987           | 5.50 | 44.16  | 46.69 | 52.90 | 62.08 |
| 256          | 387,630           | 387,472           | 1.90 | 50.72  | 53.19 | 57.06 | 63.69 |
| 512          | 290,576           | 290,519           | 1.19 | 21.29  | 23.72 | 27.31 | 32.12 |
| 1024         | 196,683           | 196,618           | 1.72 | 22.82  | 28.13 | 36.64 | 40.77 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 840,987           | 840,733           | 2.39 | 38.55  | 41.32 | 62.16 | 75.19 |
| 64           | 776,558           | 776,484           | 3.31 | 11.38  | 12.47 | 37.71 | 47.74 |
| 256          | 596,809           | 596,771           | 1.07 | 7.91   | 9.03  | 26.89 | 36.72 |
| 512          | 453,421           | 453,364           | 4.57 | 15.35  | 17.02 | 21.81 | 33.90 |
| 1024         | 303,458           | 303,437           | 2.72 | 8.36   | 9.63  | 11.31 | 19.85 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 866,224           | 866,049           | 4.97 | 24.45  | 27.11 | 47.61 | 61.70 |
| 64           | 797,536           | 797,458           | 1.54 | 11.99  | 13.31 | 37.79 | 49.19 |
| 256          | 641,474           | 641,424           | 2.21 | 8.97   | 10.42 | 33.50 | 40.08 |
| 512          | 489,928           | 489,755           | 0.65 | 8.95   | 10.38 | 19.56 | 32.24 |
| 1024         | 331,726           | 331,704           | 1.99 | 6.07   | 7.33  | 10.07 | 20.45 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 867,754           | 867,635           | 4.91 | 14.80  | 16.54 | 42.07 | 55.32 |
| 64           | 814,231           | 814,061           | 1.29 | 22.78  | 24.72 | 46.10 | 59.05 |
| 256          | 644,725           | 644,671           | 0.73 | 8.79   | 10.24 | 32.78 | 39.49 |
| 512          | 505,016           | 504,987           | 4.13 | 7.76   | 9.07  | 23.60 | 32.05 |
| 1024         | 349,286           | 349,262           | 0.41 | 9.40   | 10.73 | 12.97 | 23.29 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 1,015,080         | 1,014,844         | 0.78 | 30.60  | 34.89 | 66.73 | 76.21 |
| 64           | 951,430           | 951,310           | 1.19 | 15.50  | 17.28 | 54.96 | 60.93 |
| 256          | 773,559           | 773,485           | 0.38 | 8.96   | 12.65 | 46.64 | 51.85 |
| 512          | 597,851           | 597,762           | 0.85 | 16.64  | 18.39 | 41.94 | 47.73 |
| 1024         | 420,266           | 420,223           | 1.27 | 12.29  | 13.71 | 23.41 | 32.80 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD 4th gen EPYC)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95       | P99       |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | --------: | --------: |
| 16           | 682,518           | 682,516           | 0.21 | 0.34   | 0.38  | 21.45     | 50.64     |
| 64           | 594,913           | 594,911           | 0.14 | 0.25   | 0.29  | 15.91     | 44.02     |
| 256          | 521,845           | 521,833           | 0.14 | 0.31   | 1.46  | 11.63     | 37.32     |
| 512          | 332,714           | 332,644           | 0.11 | 1.86   | 4.97  | 3722.67⚠️ | 4983.59⚠️ |
| 1024         | 255,276           | 255,275           | 0.12 | 6.19   | 25.87 | 924.30⚠️  | 2455.94⚠️ |

⚠️ _Note: Elevated latency values at larger message sizes may indicate performance degradation or test anomalies._

### Storage Optimized

**i7i.large** - 2 vCPU, 16 GiB RAM (Intel Xeon 5th gen, local NVMe)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75       | P95       | P99       |
| -----------: | ----------------: | ----------------: | ---: | -----: | --------: | --------: | --------: |
| 16           | 1,087,424         | 1,087,406         | 0.23 | 7.91   | 40.54     | 87.50     | 98.07     |
| 64           | 963,583           | 963,581           | 0.12 | 3.36   | 28.72     | 81.37     | 90.44     |
| 256          | 784,875           | 784,680           | 0.12 | 5.36   | 14.13     | 69.68     | 82.51     |
| 512          | 636,264           | 626,772           | 0.22 | 70.22  | 3003.59⚠️ | 3429.64⚠️ | 3469.85⚠️ |
| 1024         | 395,053           | 395,039           | 0.42 | 3.87   | 6.78      | 36.23     | 50.48     |

⚠️ _Note: Size 512 shows anomalous latency spikes._

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median | P75   | P95   | P99   |
| -----------: | ----------------: | ----------------: | ---: | -----: | ----: | ----: | ----: |
| 16           | 1,024,762         | 1,024,501         | 0.45 | 31.00  | 34.69 | 67.85 | 77.74 |

_Note: Data for message sizes 64, 256, 512, and 1024 bytes not available._

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (Intel Xeon Scalable)

| Message Size | Avg. Publish Rate | Avg. Consume Rate | Min  | Median    | P75        | P95        | P99        |
| -----------: | ----------------: | ----------------: | ---: | --------: | ---------: | ---------: | ---------: |
| 16           | 664,409           | 664,406           | 0.36 | 0.97      | 8.75       | 63.00      | 74.99      |
| 64           | 637,500           | 637,474           | 0.29 | 1.82      | 7.81       | 60.23      | 72.02      |
| 256          | 230,511           | 230,439           | 0.26 | 14959.68⚠️ | 25823.07⚠️ | 39763.25⚠️ | 41257.36⚠️ |
| 512          | 128,892           | 128,855           | 0.39 | 10.62     | 96.40      | 100.48     | 729.41     |
| 1024         | 66,397            | 66,374            | 0.32 | 8.19      | 101.92     | 106.39     | 152.70     |

⚠️ _Note: Size 256 shows catastrophic latency degradation, indicating severe performance issues during test._
