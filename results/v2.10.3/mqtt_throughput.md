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

Benchmark results for AWS instance types with LavinMQ version v2.10.3.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           349,238 |           174,395 |        5.32 |        2.66 |
|    64 |           328,132 |           164,057 |       20.02 |       10.01 |
|   256 |           321,958 |           161,007 |       78.60 |       39.30 |
|   512 |           342,474 |           169,603 |      167.22 |       82.81 |
|  1024 |           330,052 |           164,182 |      322.31 |      160.33 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,522 |           167,924 |        5.11 |        2.56 |
|    64 |           352,136 |           175,385 |       21.49 |       10.70 |
|   256 |           322,308 |           163,756 |       78.68 |       39.97 |
|   512 |           328,470 |           165,317 |      160.38 |       80.72 |
|  1024 |           268,682 |           134,147 |      262.38 |      131.00 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,994 |           173,506 |        5.29 |        2.64 |
|    64 |           344,794 |           172,999 |       21.04 |       10.55 |
|   256 |           331,388 |           167,687 |       80.90 |       40.93 |
|   512 |           333,412 |           167,114 |      162.79 |       81.59 |
|  1024 |           326,837 |           161,795 |      319.17 |      158.00 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,060 |           172,015 |        5.24 |        2.62 |
|    64 |           337,666 |           168,812 |       20.60 |       10.30 |
|   256 |           333,304 |           166,456 |       81.37 |       40.63 |
|   512 |           324,408 |           162,242 |      158.40 |       79.21 |
|  1024 |           322,992 |           161,704 |      315.42 |      157.91 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,666 |           170,338 |        5.19 |        2.59 |
|    64 |           340,228 |           170,102 |       20.76 |       10.38 |
|   256 |           321,180 |           160,330 |       78.41 |       39.14 |
|   512 |           329,894 |           164,737 |      161.08 |       80.43 |
|  1024 |           322,412 |           161,236 |      314.85 |      157.45 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           357,264 |           178,641 |        5.45 |        2.72 |
|    64 |           344,042 |           172,023 |       20.99 |       10.49 |
|   256 |           324,544 |           161,772 |       79.23 |       39.49 |
|   512 |           322,298 |           161,377 |      157.37 |       78.79 |
|  1024 |           320,844 |           160,357 |      313.32 |      156.59 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,756 |           169,240 |        5.16 |        2.58 |
|    64 |           335,622 |           167,829 |       20.48 |       10.24 |
|   256 |           325,028 |           162,538 |       79.35 |       39.68 |
|   512 |           320,534 |           160,236 |      156.51 |       78.24 |
|  1024 |           318,284 |           159,109 |      310.82 |      155.37 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           279,132 |           139,601 |        4.25 |        2.13 |
|    64 |           249,042 |           124,215 |       15.20 |        7.58 |
|   256 |           264,722 |           132,369 |       64.62 |       32.31 |
|   512 |           245,516 |           122,690 |      119.88 |       59.90 |
|  1024 |           257,018 |           128,375 |      250.99 |      125.36 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,024 |           174,974 |        5.34 |        2.66 |
|    64 |           335,734 |           167,860 |       20.49 |       10.24 |
|   256 |           332,410 |           166,167 |       81.15 |       40.56 |
|   512 |           327,954 |           163,972 |      160.13 |       80.06 |
|  1024 |           321,824 |           160,971 |      314.28 |      157.19 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           216,272 |           109,301 |        3.30 |        1.66 |
|    64 |           216,498 |           108,307 |       13.21 |        6.61 |
|   256 |           205,316 |           102,650 |       50.12 |       25.06 |
|   512 |           244,110 |           122,120 |      119.19 |       59.62 |
|  1024 |           162,938 |            81,465 |      159.11 |       79.55 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           227,692 |           113,954 |        3.47 |        1.73 |
|    64 |           214,054 |           107,213 |       13.06 |        6.54 |
|   256 |           217,325 |           108,951 |       53.05 |       26.59 |
|   512 |           247,038 |           123,665 |      120.62 |       60.38 |
|  1024 |           266,852 |           133,497 |      260.59 |      130.36 |
