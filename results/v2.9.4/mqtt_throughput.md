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

Benchmark results for AWS instance types with LavinMQ version v2.9.4.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,526 |           182,174 |        5.19 |        2.77 |
|    64 |           342,496 |           177,061 |       20.90 |       10.80 |
|   256 |           330,436 |           165,231 |       80.67 |       40.33 |
|   512 |           351,404 |           177,955 |      171.58 |       86.89 |
|  1024 |           323,808 |           163,721 |      316.21 |      159.88 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,932 |           170,847 |        5.23 |        2.60 |
|    64 |           328,396 |           164,207 |       20.04 |       10.02 |
|   256 |           327,174 |           177,411 |       79.87 |       43.31 |
|   512 |           347,026 |           177,237 |      169.44 |       86.54 |
|  1024 |           295,114 |           147,188 |      288.19 |      143.73 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,764 |           174,365 |        5.32 |        2.66 |
|    64 |           350,150 |           177,268 |       21.37 |       10.81 |
|   256 |           327,274 |           165,195 |       79.90 |       40.33 |
|   512 |           344,792 |           173,394 |      168.35 |       84.66 |
|  1024 |           283,384 |           140,997 |      276.74 |      137.69 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           319,328 |           160,046 |        4.87 |        2.44 |
|    64 |           334,382 |           167,098 |       20.40 |       10.19 |
|   256 |           321,710 |           160,823 |       78.54 |       39.26 |
|   512 |           314,568 |           157,372 |      153.59 |       76.84 |
|  1024 |           319,670 |           159,870 |      312.17 |      156.12 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,386 |           167,712 |        5.11 |        2.55 |
|    64 |           318,526 |           159,161 |       19.44 |        9.71 |
|   256 |           309,844 |           154,482 |       75.64 |       37.71 |
|   512 |           317,220 |           158,644 |      154.89 |       77.46 |
|  1024 |           316,450 |           157,903 |      309.03 |      154.20 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,512 |           172,028 |        5.25 |        2.62 |
|    64 |           341,718 |           170,827 |       20.85 |       10.42 |
|   256 |           342,992 |           171,303 |       83.73 |       41.82 |
|   512 |           332,024 |           166,334 |      162.12 |       81.21 |
|  1024 |           331,038 |           166,076 |      323.27 |      162.18 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,928 |           168,461 |        5.14 |        2.57 |
|    64 |           327,058 |           163,517 |       19.96 |        9.98 |
|   256 |           314,266 |           157,222 |       76.72 |       38.38 |
|   512 |           314,886 |           157,510 |      153.75 |       76.90 |
|  1024 |           305,576 |           152,801 |      298.41 |      149.21 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           193,876 |            93,132 |        2.95 |        1.42 |
|    64 |           263,326 |           131,304 |       16.07 |        8.01 |
|   256 |           256,852 |           128,382 |       62.70 |       31.34 |
|   512 |           252,224 |           125,919 |      123.15 |       61.48 |
|  1024 |           200,232 |           100,124 |      195.53 |       97.77 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,778 |           173,244 |        5.29 |        2.64 |
|    64 |           342,816 |           171,362 |       20.92 |       10.45 |
|   256 |           331,934 |           165,784 |       81.03 |       40.47 |
|   512 |           326,040 |           163,077 |      159.19 |       79.62 |
|  1024 |           322,852 |           161,416 |      315.28 |      157.63 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           259,548 |           129,806 |        3.96 |        1.98 |
|    64 |           206,608 |           103,330 |       12.61 |        6.30 |
|   256 |           261,340 |           130,687 |       63.80 |       31.90 |
|   512 |           202,662 |           100,353 |       98.95 |       49.00 |
|  1024 |           186,026 |            92,836 |      181.66 |       90.66 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           259,768 |           129,894 |        3.96 |        1.98 |
|    64 |           264,378 |           132,364 |       16.13 |        8.07 |
|   256 |           249,852 |           125,252 |       60.99 |       30.57 |
|   512 |           253,958 |           126,980 |      124.00 |       62.00 |
|  1024 |           249,192 |           124,609 |      243.35 |      121.68 |
