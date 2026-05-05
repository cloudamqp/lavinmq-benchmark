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

Benchmark results for AWS instance types with LavinMQ version v2.7.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           359,308 |           180,765 |        5.48 |        2.75 |
|    64 |           341,688 |           181,336 |       20.85 |       11.06 |
|   256 |           336,384 |           170,496 |       82.12 |       41.62 |
|   512 |           360,418 |           179,430 |      175.98 |       87.61 |
|  1024 |           294,358 |           147,843 |      287.45 |      144.37 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,852 |           173,102 |        5.26 |        2.64 |
|    64 |           337,648 |           168,903 |       20.60 |       10.30 |
|   256 |           334,938 |           167,305 |       81.77 |       40.84 |
|   512 |           340,824 |           170,852 |      166.41 |       83.42 |
|  1024 |           269,293 |           134,021 |      262.98 |      130.87 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,114 |           182,538 |        5.26 |        2.78 |
|    64 |           356,206 |           184,388 |       21.74 |       11.25 |
|   256 |           327,526 |           164,911 |       79.96 |       40.26 |
|   512 |           346,374 |           173,076 |      169.12 |       84.50 |
|  1024 |           282,454 |           141,658 |      275.83 |      138.33 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           355,740 |           177,188 |        5.42 |        2.70 |
|    64 |           342,508 |           171,245 |       20.90 |       10.45 |
|   256 |           323,588 |           161,725 |       79.00 |       39.48 |
|   512 |           341,694 |           170,838 |      166.84 |       83.41 |
|  1024 |           337,950 |           169,350 |      330.02 |      165.38 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,266 |           170,574 |        5.19 |        2.60 |
|    64 |           321,020 |           160,948 |       19.59 |        9.82 |
|   256 |           330,050 |           165,036 |       80.57 |       40.29 |
|   512 |           332,150 |           165,979 |      162.18 |       81.04 |
|  1024 |           321,290 |           160,524 |      313.75 |      156.76 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,182 |           175,077 |        5.34 |        2.67 |
|    64 |           317,708 |           158,846 |       19.39 |        9.69 |
|   256 |           324,926 |           162,297 |       79.32 |       39.62 |
|   512 |           331,450 |           165,729 |      161.84 |       80.92 |
|  1024 |           322,070 |           161,237 |      314.52 |      157.45 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,900 |           171,799 |        5.24 |        2.62 |
|    64 |           336,458 |           168,225 |       20.53 |       10.26 |
|   256 |           332,694 |           166,338 |       81.22 |       40.60 |
|   512 |           334,898 |           167,377 |      163.52 |       81.72 |
|  1024 |           337,424 |           168,864 |      329.51 |      164.90 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           257,064 |           128,483 |        3.92 |        1.96 |
|    64 |           263,796 |           131,809 |       16.10 |        8.04 |
|   256 |           259,106 |           128,860 |       63.25 |       31.45 |
|   512 |           267,274 |           133,815 |      130.50 |       65.33 |
|  1024 |           200,422 |           100,408 |      195.72 |       98.05 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           354,516 |           177,241 |        5.40 |        2.70 |
|    64 |           343,140 |           171,565 |       20.94 |       10.47 |
|   256 |           327,542 |           163,756 |       79.96 |       39.97 |
|   512 |           325,172 |           162,715 |      158.77 |       79.45 |
|  1024 |           327,304 |           163,996 |      319.63 |      160.15 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           273,202 |           136,423 |        4.16 |        2.08 |
|    64 |           214,732 |           107,368 |       13.10 |        6.55 |
|   256 |           263,748 |           131,566 |       64.39 |       32.12 |
|   512 |           245,896 |           122,995 |      120.06 |       60.05 |
|  1024 |           181,946 |            90,893 |      177.68 |       88.76 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           267,674 |           133,836 |        4.08 |        2.04 |
|    64 |           264,588 |           132,276 |       16.14 |        8.07 |
|   256 |           248,162 |           123,653 |       60.58 |       30.18 |
|   512 |           273,198 |           136,689 |      133.39 |       66.74 |
|  1024 |           246,770 |           123,465 |      240.98 |      120.57 |
