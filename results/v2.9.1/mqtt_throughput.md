# LavinMQ MQTT Throughput Results

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> MQTT-URL (broker private IP) -> Broker

## Table Headers

- **Size**: Message size in bytes
- **Avg. Publish Rate**: Average publish rate in msgs/s
- **Avg. Consume Rate**: Average consume rate in msgs/s
- **Publish BW**: Publish bandwidth in MiB/s
- **Consume BW**: Consume bandwidth in MiB/s

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.9.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,580 |           170,951 |        5.21 |        2.60 |
|    64 |           348,894 |           174,530 |       21.29 |       10.65 |
|   256 |           340,236 |           166,183 |       83.06 |       40.57 |
|   512 |           349,696 |           179,252 |      170.75 |       87.52 |
|  1024 |           276,282 |           137,214 |      269.80 |      133.99 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,730 |           171,515 |        5.21 |        2.61 |
|    64 |           354,576 |           176,970 |       21.64 |       10.80 |
|   256 |           336,950 |           164,528 |       82.26 |       40.16 |
|   512 |           347,970 |           173,593 |      169.90 |       84.76 |
|  1024 |           302,694 |           152,082 |      295.59 |      148.51 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           334,958 |           168,140 |        5.11 |        2.56 |
|    64 |           350,454 |           194,324 |       21.39 |       11.86 |
|   256 |           344,180 |           179,328 |       84.02 |       43.78 |
|   512 |           352,544 |           176,728 |      172.14 |       86.29 |
|  1024 |           266,706 |           133,696 |      260.45 |      130.56 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           330,700 |           165,500 |        5.04 |        2.52 |
|    64 |           320,682 |           160,273 |       19.57 |        9.78 |
|   256 |           319,514 |           159,719 |       78.00 |       38.99 |
|   512 |           329,208 |           164,957 |      160.74 |       80.54 |
|  1024 |           327,732 |           163,554 |      320.05 |      159.72 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           359,148 |           179,646 |        5.48 |        2.74 |
|    64 |           334,148 |           166,993 |       20.39 |       10.19 |
|   256 |           322,648 |           161,505 |       78.77 |       39.42 |
|   512 |           324,818 |           162,391 |      158.60 |       79.29 |
|  1024 |           323,326 |           161,723 |      315.74 |      157.93 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,106 |           166,553 |        5.08 |        2.54 |
|    64 |           327,944 |           163,894 |       20.01 |       10.00 |
|   256 |           332,599 |           166,104 |       81.20 |       40.55 |
|   512 |           306,968 |           153,437 |      149.88 |       74.92 |
|  1024 |           320,712 |           160,280 |      313.19 |      156.52 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,494 |           172,290 |        5.25 |        2.62 |
|    64 |           335,668 |           167,794 |       20.48 |       10.24 |
|   256 |           335,276 |           167,606 |       81.85 |       40.91 |
|   512 |           344,528 |           172,285 |      168.22 |       84.12 |
|  1024 |           331,850 |           165,934 |      324.07 |      162.04 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,674 |           168,351 |        5.13 |        2.56 |
|    64 |           342,038 |           170,904 |       20.87 |       10.43 |
|   256 |           330,950 |           165,663 |       80.79 |       40.44 |
|   512 |           339,080 |           169,563 |      165.56 |       82.79 |
|  1024 |           321,326 |           160,471 |      313.79 |      156.70 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           269,382 |           134,800 |        4.11 |        2.05 |
|    64 |           267,309 |           132,999 |       16.31 |        8.11 |
|   256 |           249,908 |           125,010 |       61.01 |       30.52 |
|   512 |           255,164 |           127,666 |      124.59 |       62.33 |
|  1024 |           252,084 |           126,073 |      246.17 |      123.11 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           225,156 |           112,474 |        3.43 |        1.71 |
|    64 |           274,686 |           137,115 |       16.76 |        8.36 |
|   256 |           283,748 |           141,899 |       69.27 |       34.64 |
|   512 |           264,007 |           132,015 |      128.90 |       64.46 |
|  1024 |           261,983 |           130,920 |      255.84 |      127.85 |
