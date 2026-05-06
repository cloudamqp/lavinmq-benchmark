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

Benchmark results for AWS instance types with LavinMQ version v2.7.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,222 |           173,563 |        5.29 |        2.64 |
|    64 |           346,864 |           173,166 |       21.17 |       10.56 |
|   256 |           343,478 |           172,222 |       83.85 |       42.04 |
|   512 |           337,655 |           167,869 |      164.87 |       81.96 |
|  1024 |           298,756 |           149,252 |      291.75 |      145.75 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           323,740 |           161,896 |        4.93 |        2.47 |
|    64 |           349,620 |           174,724 |       21.33 |       10.66 |
|   256 |           342,104 |           171,950 |       83.52 |       41.97 |
|   512 |           319,024 |           157,278 |      155.77 |       76.79 |
|  1024 |           282,368 |           141,180 |      275.75 |      137.87 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           355,366 |           177,666 |        5.42 |        2.71 |
|    64 |           342,432 |           182,118 |       20.90 |       11.11 |
|   256 |           346,090 |           178,959 |       84.49 |       43.69 |
|   512 |           347,946 |           174,209 |      169.89 |       85.06 |
|  1024 |           278,858 |           138,222 |      272.32 |      134.98 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,122 |           174,008 |        5.31 |        2.65 |
|    64 |           341,980 |           171,043 |       20.87 |       10.43 |
|   256 |           325,782 |           163,066 |       79.53 |       39.81 |
|   512 |           328,998 |           164,535 |      160.64 |       80.33 |
|  1024 |           319,122 |           159,589 |      311.64 |      155.84 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,968 |           173,652 |        5.29 |        2.64 |
|    64 |           334,154 |           167,099 |       20.39 |       10.19 |
|   256 |           315,198 |           156,894 |       76.95 |       38.30 |
|   512 |           326,382 |           163,286 |      159.36 |       79.72 |
|  1024 |           322,210 |           161,118 |      314.65 |      157.34 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,880 |           168,858 |        5.15 |        2.57 |
|    64 |           324,090 |           162,061 |       19.78 |        9.89 |
|   256 |           319,948 |           159,970 |       78.11 |       39.05 |
|   512 |           318,812 |           159,584 |      155.66 |       77.92 |
|  1024 |           323,718 |           162,091 |      316.13 |      158.29 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           354,022 |           176,962 |        5.40 |        2.70 |
|    64 |           342,786 |           171,447 |       20.92 |       10.46 |
|   256 |           334,930 |           167,435 |       81.77 |       40.87 |
|   512 |           339,214 |           169,592 |      165.63 |       82.80 |
|  1024 |           327,218 |           163,615 |      319.54 |      159.78 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           285,760 |           142,809 |        4.36 |        2.17 |
|    64 |           271,426 |           135,615 |       16.56 |        8.27 |
|   256 |           267,182 |           133,595 |       65.22 |       32.61 |
|   512 |           264,098 |           132,065 |      128.95 |       64.48 |
|  1024 |           264,992 |           132,724 |      258.78 |      129.61 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,938 |           172,956 |        5.27 |        2.63 |
|    64 |           332,746 |           166,426 |       20.30 |       10.15 |
|   256 |           322,948 |           161,472 |       78.84 |       39.42 |
|   512 |           328,278 |           163,815 |      160.29 |       79.98 |
|  1024 |           323,264 |           161,563 |      315.68 |      157.77 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           253,358 |           126,768 |        3.86 |        1.93 |
|    64 |           253,524 |           126,774 |       15.47 |        7.73 |
|   256 |           246,192 |           122,084 |       60.10 |       29.80 |
|   512 |           247,972 |           123,967 |      121.08 |       60.53 |
|  1024 |           249,098 |           124,643 |      243.25 |      121.72 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           262,710 |           131,355 |        4.00 |        2.00 |
|    64 |           237,624 |           118,566 |       14.50 |        7.23 |
|   256 |           255,310 |           127,646 |       62.33 |       31.16 |
|   512 |           264,184 |           132,098 |      128.99 |       64.50 |
|  1024 |           215,368 |           107,674 |      210.32 |      105.15 |
