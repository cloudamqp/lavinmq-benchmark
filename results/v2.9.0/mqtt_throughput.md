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

Benchmark results for AWS instance types with LavinMQ version v2.9.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           360,626 |           188,812 |        5.50 |        2.88 |
|    64 |           361,662 |           199,736 |       22.07 |       12.19 |
|   256 |           348,420 |           176,225 |       85.06 |       43.02 |
|   512 |           353,610 |           178,138 |      172.66 |       86.98 |
|  1024 |           273,798 |           136,838 |      267.38 |      133.63 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           349,358 |           174,874 |        5.33 |        2.66 |
|    64 |           338,592 |           169,307 |       20.66 |       10.33 |
|   256 |           333,120 |           166,435 |       81.32 |       40.63 |
|   512 |           343,902 |           167,619 |      167.92 |       81.84 |
|  1024 |           285,988 |           142,532 |      279.28 |      139.19 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,882 |           180,445 |        5.27 |        2.75 |
|    64 |           351,570 |           189,569 |       21.45 |       11.57 |
|   256 |           352,222 |           179,632 |       85.99 |       43.85 |
|   512 |           329,820 |           165,243 |      161.04 |       80.68 |
|  1024 |           309,550 |           154,728 |      302.29 |      151.10 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,882 |           171,468 |        5.23 |        2.61 |
|    64 |           341,048 |           170,435 |       20.81 |       10.40 |
|   256 |           329,558 |           164,095 |       80.45 |       40.06 |
|   512 |           341,548 |           170,508 |      166.77 |       83.25 |
|  1024 |           334,182 |           166,607 |      326.34 |      162.70 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,702 |           170,306 |        5.19 |        2.59 |
|    64 |           331,906 |           165,868 |       20.25 |       10.12 |
|   256 |           324,642 |           162,303 |       79.25 |       39.62 |
|   512 |           328,392 |           164,088 |      160.34 |       80.12 |
|  1024 |           318,262 |           159,426 |      310.80 |      155.68 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,006 |           164,713 |        5.02 |        2.51 |
|    64 |           326,960 |           163,588 |       19.95 |        9.98 |
|   256 |           308,818 |           154,445 |       75.39 |       37.70 |
|   512 |           321,012 |           160,309 |      156.74 |       78.27 |
|  1024 |           324,198 |           161,747 |      316.59 |      157.95 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,736 |           167,808 |        5.12 |        2.56 |
|    64 |           338,238 |           169,177 |       20.64 |       10.32 |
|   256 |           328,202 |           164,076 |       80.12 |       40.05 |
|   512 |           332,872 |           166,546 |      162.53 |       81.32 |
|  1024 |           327,140 |           163,402 |      319.47 |      159.57 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           257,324 |           128,920 |        3.92 |        1.96 |
|    64 |           216,134 |           108,049 |       13.19 |        6.59 |
|   256 |           260,628 |           130,681 |       63.62 |       31.90 |
|   512 |           208,198 |           103,936 |      101.65 |       50.75 |
|  1024 |           277,922 |           139,869 |      271.40 |      136.59 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,880 |           169,071 |        5.15 |        2.57 |
|    64 |           341,270 |           170,572 |       20.82 |       10.41 |
|   256 |           331,686 |           165,857 |       80.97 |       40.49 |
|   512 |           318,588 |           159,334 |      155.56 |       77.79 |
|  1024 |           322,650 |           161,257 |      315.08 |      157.47 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           200,590 |           100,430 |        3.06 |        1.53 |
|    64 |           202,001 |           101,199 |       12.32 |        6.17 |
|   256 |           262,316 |           130,619 |       64.04 |       31.88 |
|   512 |           283,710 |           141,854 |      138.53 |       69.26 |
|  1024 |           195,762 |            97,785 |      191.17 |       95.49 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,616 |           135,290 |        4.12 |        2.06 |
|    64 |           256,758 |           128,514 |       15.67 |        7.84 |
|   256 |           246,952 |           123,491 |       60.29 |       30.14 |
|   512 |           249,422 |           124,910 |      121.78 |       60.99 |
|  1024 |           267,356 |           133,823 |      261.08 |      130.68 |
