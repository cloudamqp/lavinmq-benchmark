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

Benchmark results for AWS instance types with LavinMQ version v2.10.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,802 |           178,748 |        5.26 |        2.72 |
|    64 |           353,522 |           175,583 |       21.57 |       10.71 |
|   256 |           339,398 |           173,474 |       82.86 |       42.35 |
|   512 |           344,446 |           171,838 |      168.18 |       83.90 |
|  1024 |           298,936 |           149,260 |      291.92 |      145.76 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,176 |           174,450 |        5.31 |        2.66 |
|    64 |           346,900 |           173,116 |       21.17 |       10.56 |
|   256 |           339,180 |           169,348 |       82.80 |       41.34 |
|   512 |           336,528 |           168,211 |      164.32 |       82.13 |
|  1024 |           305,486 |           152,922 |      298.32 |      149.33 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,516 |           171,264 |        5.22 |        2.61 |
|    64 |           350,508 |           180,016 |       21.39 |       10.98 |
|   256 |           336,342 |           167,775 |       82.11 |       40.96 |
|   512 |           335,340 |           167,617 |      163.74 |       81.84 |
|  1024 |           319,704 |           159,469 |      312.21 |      155.73 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,066 |           172,246 |        5.25 |        2.62 |
|    64 |           333,246 |           166,634 |       20.33 |       10.17 |
|   256 |           332,268 |           166,255 |       81.12 |       40.58 |
|   512 |           322,538 |           161,200 |      157.48 |       78.71 |
|  1024 |           336,926 |           168,391 |      329.02 |      164.44 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,524 |           167,851 |        5.11 |        2.56 |
|    64 |           333,812 |           167,001 |       20.37 |       10.19 |
|   256 |           337,106 |           168,571 |       82.30 |       41.15 |
|   512 |           319,130 |           159,491 |      155.82 |       77.87 |
|  1024 |           322,644 |           161,397 |      315.08 |      157.61 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,772 |           170,474 |        5.19 |        2.60 |
|    64 |           320,640 |           160,415 |       19.57 |        9.79 |
|   256 |           330,016 |           165,074 |       80.57 |       40.30 |
|   512 |           332,614 |           166,073 |      162.40 |       81.09 |
|  1024 |           320,318 |           160,157 |      312.81 |      156.40 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,320 |           174,167 |        5.31 |        2.65 |
|    64 |           336,878 |           168,260 |       20.56 |       10.26 |
|   256 |           341,528 |           170,787 |       83.38 |       41.69 |
|   512 |           329,212 |           164,654 |      160.74 |       80.39 |
|  1024 |           319,476 |           159,768 |      311.98 |      156.02 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           271,288 |           135,653 |        4.13 |        2.06 |
|    64 |           270,760 |           135,592 |       16.52 |        8.27 |
|   256 |           257,437 |           128,808 |       62.85 |       31.44 |
|   512 |           173,316 |            87,263 |       84.62 |       42.60 |
|  1024 |           246,602 |           122,776 |      240.82 |      119.89 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,774 |           164,786 |        5.03 |        2.51 |
|    64 |           337,644 |           168,809 |       20.60 |       10.30 |
|   256 |           325,464 |           162,819 |       79.45 |       39.75 |
|   512 |           316,580 |           158,334 |      154.58 |       77.31 |
|  1024 |           326,410 |           163,170 |      318.75 |      159.34 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           209,269 |           104,856 |        3.19 |        1.59 |
|    64 |           204,786 |           102,436 |       12.49 |        6.25 |
|   256 |           207,872 |            89,806 |       50.75 |       21.92 |
|   512 |           258,702 |           129,806 |      126.31 |       63.38 |
|  1024 |           248,426 |           124,152 |      242.60 |      121.24 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           288,209 |           144,529 |        4.39 |        2.20 |
|    64 |           262,852 |           131,402 |       16.04 |        8.02 |
|   256 |           278,526 |           139,245 |       67.99 |       33.99 |
|   512 |           275,774 |           137,836 |      134.65 |       67.30 |
|  1024 |           249,986 |           125,462 |      244.12 |      122.52 |
