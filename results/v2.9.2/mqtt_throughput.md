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

Benchmark results for AWS instance types with LavinMQ version v2.9.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,458 |           174,659 |        5.34 |        2.66 |
|    64 |           341,676 |           189,610 |       20.85 |       11.57 |
|   256 |           347,924 |           174,233 |       84.94 |       42.53 |
|   512 |           345,766 |           173,519 |      168.83 |       84.72 |
|  1024 |           275,574 |           137,465 |      269.11 |      134.24 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           367,182 |           240,378 |        5.60 |        3.66 |
|    64 |           352,532 |           211,726 |       21.51 |       12.92 |
|   256 |           363,120 |           180,609 |       88.65 |       44.09 |
|   512 |           319,824 |           159,844 |      156.16 |       78.04 |
|  1024 |           250,684 |           125,216 |      244.80 |      122.28 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,914 |           173,811 |        5.30 |        2.65 |
|    64 |           328,368 |           164,214 |       20.04 |       10.02 |
|   256 |           341,142 |           176,992 |       83.28 |       43.21 |
|   512 |           345,158 |           170,677 |      168.53 |       83.33 |
|  1024 |           312,832 |           156,107 |      305.50 |      152.44 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,080 |           167,558 |        5.11 |        2.55 |
|    64 |           341,828 |           170,934 |       20.86 |       10.43 |
|   256 |           324,632 |           162,062 |       79.25 |       39.56 |
|   512 |           331,286 |           165,622 |      161.76 |       80.87 |
|  1024 |           332,778 |           165,878 |      324.97 |      161.99 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,710 |           166,297 |        5.07 |        2.53 |
|    64 |           338,628 |           169,311 |       20.66 |       10.33 |
|   256 |           328,638 |           164,064 |       80.23 |       40.05 |
|   512 |           323,958 |           161,998 |      158.18 |       79.10 |
|  1024 |           323,678 |           161,890 |      316.09 |      158.09 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,310 |           173,144 |        5.28 |        2.64 |
|    64 |           327,344 |           163,471 |       19.97 |        9.97 |
|   256 |           322,730 |           161,519 |       78.79 |       39.43 |
|   512 |           328,178 |           164,072 |      160.24 |       80.11 |
|  1024 |           323,110 |           161,537 |      315.53 |      157.75 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,053 |           165,914 |        5.08 |        2.53 |
|    64 |           330,202 |           165,076 |       20.15 |       10.07 |
|   256 |           337,232 |           168,562 |       82.33 |       41.15 |
|   512 |           327,482 |           163,703 |      159.90 |       79.93 |
|  1024 |           333,178 |           166,590 |      325.36 |      162.68 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           187,710 |            94,049 |        2.86 |        1.43 |
|    64 |           202,078 |           101,013 |       12.33 |        6.16 |
|   256 |           248,994 |           124,663 |       60.78 |       30.43 |
|   512 |           178,866 |            89,594 |       87.33 |       43.74 |
|  1024 |           269,410 |           135,322 |      263.09 |      132.15 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,008 |           171,485 |        5.23 |        2.61 |
|    64 |           332,298 |           166,113 |       20.28 |       10.13 |
|   256 |           324,294 |           162,252 |       79.17 |       39.61 |
|   512 |           310,178 |           154,991 |      151.45 |       75.67 |
|  1024 |           318,360 |           158,996 |      310.89 |      155.26 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           265,738 |           132,739 |        4.05 |        2.02 |
|    64 |           261,760 |           130,888 |       15.97 |        7.98 |
|   256 |           197,552 |            89,535 |       48.23 |       21.85 |
|   512 |           241,038 |           120,688 |      117.69 |       58.92 |
|  1024 |           198,286 |            98,976 |      193.63 |       96.65 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           296,878 |           148,442 |        4.52 |        2.26 |
|    64 |           285,368 |           142,661 |       17.41 |        8.70 |
|   256 |           207,128 |           103,305 |       50.56 |       25.22 |
|   512 |           264,660 |           132,573 |      129.22 |       64.73 |
|  1024 |           229,628 |           115,300 |      224.24 |      112.59 |
