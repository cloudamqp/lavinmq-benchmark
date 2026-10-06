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

Benchmark results for AWS instance types with LavinMQ version v2.10.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,828 |           239,245 |        5.27 |        3.65 |
|    64 |           358,052 |           188,703 |       21.85 |       11.51 |
|   256 |           336,434 |           176,662 |       82.13 |       43.13 |
|   512 |           337,744 |           166,939 |      164.91 |       81.51 |
|  1024 |           281,634 |           140,608 |      275.03 |      137.31 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,114 |           165,093 |        5.02 |        2.51 |
|    64 |           324,740 |           162,007 |       19.82 |        9.88 |
|   256 |           338,612 |           177,645 |       82.66 |       43.37 |
|   512 |           338,440 |           168,931 |      165.25 |       82.48 |
|  1024 |           298,358 |           148,911 |      291.36 |      145.42 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,836 |           167,906 |        5.12 |        2.56 |
|    64 |           335,136 |           167,600 |       20.45 |       10.22 |
|   256 |           330,980 |           165,507 |       80.80 |       40.40 |
|   512 |           340,912 |           170,677 |      166.46 |       83.33 |
|  1024 |           329,194 |           165,690 |      321.47 |      161.80 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,022 |           171,683 |        5.23 |        2.61 |
|    64 |           325,014 |           162,472 |       19.83 |        9.91 |
|   256 |           319,750 |           159,851 |       78.06 |       39.02 |
|   512 |           321,252 |           160,399 |      156.86 |       78.31 |
|  1024 |           324,954 |           162,459 |      317.33 |      158.65 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,040 |           172,013 |        5.24 |        2.62 |
|    64 |           336,864 |           168,045 |       20.56 |       10.25 |
|   256 |           325,850 |           162,974 |       79.55 |       39.78 |
|   512 |           327,154 |           163,298 |      159.74 |       79.73 |
|  1024 |           327,670 |           163,775 |      319.99 |      159.93 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,170 |           169,615 |        5.17 |        2.58 |
|    64 |           341,574 |           170,468 |       20.84 |       10.40 |
|   256 |           320,656 |           160,420 |       78.28 |       39.16 |
|   512 |           318,788 |           159,408 |      155.65 |       77.83 |
|  1024 |           316,832 |           158,403 |      309.40 |      154.69 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           355,526 |           178,032 |        5.42 |        2.71 |
|    64 |           336,038 |           168,038 |       20.51 |       10.25 |
|   256 |           331,740 |           165,864 |       80.99 |       40.49 |
|   512 |           332,314 |           166,189 |      162.26 |       81.14 |
|  1024 |           317,279 |           158,774 |      309.84 |      155.05 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           218,712 |           109,121 |        3.33 |        1.66 |
|    64 |           258,408 |           129,176 |       15.77 |        7.88 |
|   256 |           261,102 |           130,560 |       63.74 |       31.87 |
|   512 |           199,316 |            99,651 |       97.32 |       48.65 |
|  1024 |           238,734 |           119,257 |      233.13 |      116.46 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,054 |           170,605 |        5.20 |        2.60 |
|    64 |           341,442 |           170,668 |       20.83 |       10.41 |
|   256 |           331,766 |           166,002 |       80.99 |       40.52 |
|   512 |           324,452 |           162,047 |      158.42 |       79.12 |
|  1024 |           330,910 |           165,359 |      323.15 |      161.48 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           248,940 |           124,656 |        3.79 |        1.90 |
|    64 |           246,404 |           123,150 |       15.03 |        7.51 |
|   256 |           178,730 |            89,194 |       43.63 |       21.77 |
|   512 |           261,248 |           130,322 |      127.56 |       63.63 |
|  1024 |           260,510 |           130,604 |      254.40 |      127.54 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           291,428 |           145,615 |        4.44 |        2.22 |
|    64 |           219,766 |           110,849 |       13.41 |        6.76 |
|   256 |           255,676 |           127,899 |       62.42 |       31.22 |
|   512 |           229,954 |           114,953 |      112.28 |       56.12 |
|  1024 |           281,818 |           140,911 |      275.21 |      137.60 |
