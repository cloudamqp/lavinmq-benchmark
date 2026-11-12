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

Benchmark results for AWS instance types with LavinMQ version v2.11.0-rc.4.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,514 |           170,744 |        5.21 |        2.60 |
|    64 |           344,882 |           183,474 |       21.04 |       11.19 |
|   256 |           336,102 |           168,624 |       82.05 |       41.16 |
|   512 |           326,994 |           166,825 |      159.66 |       81.45 |
|  1024 |           306,912 |           154,442 |      299.71 |      150.82 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,830 |           172,320 |        5.26 |        2.62 |
|    64 |           344,307 |           173,915 |       21.01 |       10.61 |
|   256 |           342,295 |           176,195 |       83.56 |       43.01 |
|   512 |           343,372 |           172,753 |      167.66 |       84.35 |
|  1024 |           319,724 |           159,614 |      312.23 |      155.87 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           349,390 |           174,395 |        5.33 |        2.66 |
|    64 |           316,514 |           158,254 |       19.31 |        9.65 |
|   256 |           320,974 |           160,831 |       78.36 |       39.26 |
|   512 |           343,208 |           172,191 |      167.58 |       84.07 |
|  1024 |           293,194 |           144,261 |      286.32 |      140.87 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           321,484 |           160,888 |        4.90 |        2.45 |
|    64 |           324,204 |           162,117 |       19.78 |        9.89 |
|   256 |           319,840 |           159,926 |       78.08 |       39.04 |
|   512 |           319,844 |           159,343 |      156.17 |       77.80 |
|  1024 |           317,376 |           158,873 |      309.93 |      155.14 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,206 |           169,560 |        5.17 |        2.58 |
|    64 |           319,322 |           159,684 |       19.48 |        9.74 |
|   256 |           328,154 |           164,034 |       80.11 |       40.04 |
|   512 |           326,400 |           163,235 |      159.37 |       79.70 |
|  1024 |           317,170 |           158,521 |      309.73 |      154.80 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,532 |           170,770 |        5.21 |        2.60 |
|    64 |           323,428 |           161,670 |       19.74 |        9.86 |
|   256 |           330,530 |           165,483 |       80.69 |       40.40 |
|   512 |           323,178 |           161,672 |      157.80 |       78.94 |
|  1024 |           319,892 |           159,984 |      312.39 |      156.23 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,466 |           170,705 |        5.21 |        2.60 |
|    64 |           337,900 |           168,950 |       20.62 |       10.31 |
|   256 |           327,036 |           163,531 |       79.84 |       39.92 |
|   512 |           322,036 |           161,049 |      157.24 |       78.63 |
|  1024 |           326,104 |           162,974 |      318.46 |      159.15 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           273,988 |           136,996 |        4.18 |        2.09 |
|    64 |           298,272 |           149,198 |       18.20 |        9.10 |
|   256 |           269,584 |           134,788 |       65.81 |       32.90 |
|   512 |           203,512 |           101,835 |       99.37 |       49.72 |
|  1024 |           246,114 |           123,051 |      240.34 |      120.16 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,882 |           173,087 |        5.27 |        2.64 |
|    64 |           342,866 |           171,455 |       20.92 |       10.46 |
|   256 |           320,354 |           160,151 |       78.21 |       39.09 |
|   512 |           314,558 |           157,285 |      153.59 |       76.79 |
|  1024 |           313,142 |           156,574 |      305.80 |      152.90 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           269,810 |           134,976 |        4.11 |        2.05 |
|    64 |           264,580 |           132,293 |       16.14 |        8.07 |
|   256 |           248,694 |           124,375 |       60.71 |       30.36 |
|   512 |           186,928 |            93,715 |       91.27 |       45.75 |
|  1024 |           259,916 |           129,961 |      253.82 |      126.91 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           261,782 |           130,870 |        3.99 |        1.99 |
|    64 |           259,466 |           130,137 |       15.83 |        7.94 |
|   256 |           256,044 |           128,060 |       62.51 |       31.26 |
|   512 |           255,978 |           127,947 |      124.98 |       62.47 |
|  1024 |           252,024 |           126,127 |      246.11 |      123.17 |
