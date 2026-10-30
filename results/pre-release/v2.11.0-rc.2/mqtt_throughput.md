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

Benchmark results for AWS instance types with LavinMQ version v2.11.0-rc.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           356,318 |           180,694 |        5.43 |        2.75 |
|    64 |           346,022 |           171,809 |       21.11 |       10.48 |
|   256 |           343,728 |           172,015 |       83.91 |       41.99 |
|   512 |           325,088 |           163,987 |      158.73 |       80.07 |
|  1024 |           248,292 |           123,984 |      242.47 |      121.07 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,658 |           176,589 |        5.07 |        2.69 |
|    64 |           348,386 |           188,155 |       21.26 |       11.48 |
|   256 |           347,884 |           182,748 |       84.93 |       44.61 |
|   512 |           326,348 |           161,157 |      159.34 |       78.68 |
|  1024 |           228,384 |           114,266 |      223.03 |      111.58 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,292 |           175,641 |        5.23 |        2.68 |
|    64 |           332,088 |           172,507 |       20.26 |       10.52 |
|   256 |           351,974 |           177,487 |       85.93 |       43.33 |
|   512 |           339,742 |           170,123 |      165.88 |       83.06 |
|  1024 |           229,548 |           114,753 |      224.16 |      112.06 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           323,066 |           161,616 |        4.92 |        2.46 |
|    64 |           337,008 |           168,485 |       20.56 |       10.28 |
|   256 |           322,458 |           161,446 |       78.72 |       39.41 |
|   512 |           311,800 |           156,050 |      152.24 |       76.19 |
|  1024 |           313,754 |           156,719 |      306.40 |      153.04 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           324,990 |           162,487 |        4.95 |        2.47 |
|    64 |           310,456 |           155,316 |       18.94 |        9.47 |
|   256 |           305,732 |           152,791 |       74.64 |       37.30 |
|   512 |           310,968 |           155,516 |      151.83 |       75.93 |
|  1024 |           302,840 |           151,396 |      295.74 |      147.84 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           324,932 |           162,506 |        4.95 |        2.47 |
|    64 |           335,894 |           167,855 |       20.50 |       10.24 |
|   256 |           322,042 |           161,034 |       78.62 |       39.31 |
|   512 |           342,858 |           171,230 |      167.41 |       83.60 |
|  1024 |           330,074 |           164,998 |      322.33 |      161.13 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,626 |           169,725 |        5.18 |        2.58 |
|    64 |           325,714 |           162,707 |       19.88 |        9.93 |
|   256 |           304,858 |           152,611 |       74.42 |       37.25 |
|   512 |           314,368 |           157,130 |      153.50 |       76.72 |
|  1024 |           310,820 |           155,658 |      303.53 |      152.00 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           271,034 |           135,312 |        4.13 |        2.06 |
|    64 |           256,548 |           127,835 |       15.65 |        7.80 |
|   256 |           265,548 |           132,808 |       64.83 |       32.42 |
|   512 |           262,790 |           131,351 |      128.31 |       64.13 |
|  1024 |           251,396 |           125,704 |      245.50 |      122.75 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,678 |           167,866 |        5.12 |        2.56 |
|    64 |           331,208 |           165,556 |       20.21 |       10.10 |
|   256 |           325,278 |           162,617 |       79.41 |       39.70 |
|   512 |           331,102 |           165,403 |      161.67 |       80.76 |
|  1024 |           323,056 |           161,521 |      315.48 |      157.73 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           245,716 |           122,843 |        3.74 |        1.87 |
|    64 |           199,010 |            99,283 |       12.14 |        6.05 |
|   256 |           170,134 |            85,071 |       41.53 |       20.76 |
|   512 |           235,126 |           117,578 |      114.80 |       57.41 |
|  1024 |           196,718 |            97,968 |      192.10 |       95.67 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           263,642 |           122,747 |        4.02 |        1.87 |
|    64 |           261,084 |           130,483 |       15.93 |        7.96 |
|   256 |           252,830 |           126,627 |       61.72 |       30.91 |
|   512 |           264,408 |           132,223 |      129.10 |       64.56 |
|  1024 |           263,804 |           131,922 |      257.62 |      128.83 |
