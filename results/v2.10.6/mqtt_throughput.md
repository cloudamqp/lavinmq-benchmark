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

Benchmark results for AWS instance types with LavinMQ version v2.10.6.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           326,224 |           165,632 |        4.97 |        2.52 |
|    64 |           330,198 |           165,458 |       20.15 |       10.09 |
|   256 |           338,046 |           173,787 |       82.53 |       42.42 |
|   512 |           332,048 |           166,041 |      162.13 |       81.07 |
|  1024 |           307,916 |           152,014 |      300.69 |      148.45 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,600 |           175,965 |        5.36 |        2.68 |
|    64 |           334,542 |           167,325 |       20.41 |       10.21 |
|   256 |           336,058 |           167,975 |       82.04 |       41.00 |
|   512 |           332,692 |           167,621 |      162.44 |       81.84 |
|  1024 |           305,916 |           152,350 |      298.74 |      148.77 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,930 |           171,952 |        5.24 |        2.62 |
|    64 |           338,906 |           173,964 |       20.68 |       10.61 |
|   256 |           341,178 |           171,864 |       83.29 |       41.95 |
|   512 |           342,458 |           170,978 |      167.21 |       83.48 |
|  1024 |           337,630 |           168,330 |      329.71 |      164.38 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,446 |           168,847 |        5.14 |        2.57 |
|    64 |           322,230 |           161,101 |       19.66 |        9.83 |
|   256 |           317,262 |           158,543 |       77.45 |       38.70 |
|   512 |           321,564 |           160,785 |      157.01 |       78.50 |
|  1024 |           317,346 |           158,622 |      309.90 |      154.90 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           326,160 |           163,063 |        4.97 |        2.48 |
|    64 |           334,816 |           167,421 |       20.43 |       10.21 |
|   256 |           323,454 |           161,980 |       78.96 |       39.54 |
|   512 |           322,068 |           161,084 |      157.25 |       78.65 |
|  1024 |           321,348 |           160,591 |      313.81 |      156.82 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           356,722 |           178,412 |        5.44 |        2.72 |
|    64 |           332,852 |           166,451 |       20.31 |       10.15 |
|   256 |           332,830 |           166,432 |       81.25 |       40.63 |
|   512 |           323,936 |           161,883 |      158.17 |       79.04 |
|  1024 |           322,964 |           161,625 |      315.39 |      157.83 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,492 |           166,161 |        5.07 |        2.53 |
|    64 |           313,878 |           156,933 |       19.15 |        9.57 |
|   256 |           308,270 |           154,153 |       75.26 |       37.63 |
|   512 |           325,824 |           162,745 |      159.09 |       79.46 |
|  1024 |           313,082 |           156,573 |      305.74 |      152.90 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,198 |           134,911 |        4.12 |        2.05 |
|    64 |           260,162 |           130,081 |       15.87 |        7.93 |
|   256 |           263,826 |           131,896 |       64.41 |       32.20 |
|   512 |           168,974 |            84,858 |       82.50 |       41.43 |
|  1024 |           241,470 |           120,920 |      235.81 |      118.08 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           328,664 |           164,303 |        5.01 |        2.50 |
|    64 |           339,000 |           169,470 |       20.69 |       10.34 |
|   256 |           329,980 |           165,133 |       80.56 |       40.31 |
|   512 |           325,574 |           162,782 |      158.97 |       79.48 |
|  1024 |           319,967 |           159,798 |      312.46 |      156.05 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,820 |           135,367 |        4.13 |        2.06 |
|    64 |           207,478 |           103,686 |       12.66 |        6.32 |
|   256 |           197,298 |            98,789 |       48.16 |       24.11 |
|   512 |           241,452 |           120,696 |      117.89 |       58.93 |
|  1024 |           250,958 |           125,493 |      245.07 |      122.55 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           263,694 |           131,850 |        4.02 |        2.01 |
|    64 |           230,818 |           115,392 |       14.08 |        7.04 |
|   256 |           172,342 |            86,168 |       42.07 |       21.03 |
|   512 |           263,968 |           131,957 |      128.89 |       64.43 |
|  1024 |           256,934 |           128,488 |      250.91 |      125.47 |
