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

Benchmark results for AWS instance types with LavinMQ version v2.11.0-rc.3.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,650 |           167,467 |        5.15 |        2.55 |
|    64 |           337,248 |           168,608 |       20.58 |       10.29 |
|   256 |           336,104 |           174,832 |       82.05 |       42.68 |
|   512 |           347,930 |           175,392 |      169.88 |       85.64 |
|  1024 |           332,362 |           166,097 |      324.57 |      162.20 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           354,128 |           176,876 |        5.40 |        2.69 |
|    64 |           339,928 |           177,435 |       20.74 |       10.82 |
|   256 |           336,978 |           174,426 |       82.27 |       42.58 |
|   512 |           345,220 |           172,551 |      168.56 |       84.25 |
|  1024 |           271,200 |           133,198 |      264.84 |      130.07 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,296 |           166,190 |        5.07 |        2.53 |
|    64 |           324,478 |           164,209 |       19.80 |       10.02 |
|   256 |           328,332 |           162,713 |       80.15 |       39.72 |
|   512 |           331,822 |           167,463 |      162.02 |       81.76 |
|  1024 |           282,768 |           140,251 |      276.14 |      136.96 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,488 |           173,754 |        5.30 |        2.65 |
|    64 |           318,568 |           159,344 |       19.44 |        9.72 |
|   256 |           326,244 |           162,228 |       79.64 |       39.60 |
|   512 |           310,958 |           155,487 |      151.83 |       75.92 |
|  1024 |           310,550 |           155,289 |      303.27 |      151.64 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,650 |           170,811 |        5.21 |        2.60 |
|    64 |           314,606 |           156,089 |       19.20 |        9.52 |
|   256 |           308,870 |           154,311 |       75.40 |       37.67 |
|   512 |           310,376 |           155,163 |      151.55 |       75.76 |
|  1024 |           321,304 |           160,638 |      313.77 |      156.87 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,896 |           171,433 |        5.23 |        2.61 |
|    64 |           337,922 |           168,963 |       20.62 |       10.31 |
|   256 |           327,918 |           163,944 |       80.05 |       40.02 |
|   512 |           334,506 |           167,297 |      163.33 |       81.68 |
|  1024 |           329,190 |           164,671 |      321.47 |      160.81 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,770 |           174,426 |        5.32 |        2.66 |
|    64 |           339,116 |           169,422 |       20.69 |       10.34 |
|   256 |           331,498 |           165,866 |       80.93 |       40.49 |
|   512 |           337,274 |           168,626 |      164.68 |       82.33 |
|  1024 |           319,566 |           159,792 |      312.07 |      156.04 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           271,758 |           135,758 |        4.14 |        2.07 |
|    64 |           270,260 |           135,043 |       16.49 |        8.24 |
|   256 |           260,814 |           130,599 |       63.67 |       31.88 |
|   512 |           254,640 |           127,298 |      124.33 |       62.15 |
|  1024 |           272,522 |           135,375 |      266.13 |      132.20 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,858 |           172,405 |        5.26 |        2.63 |
|    64 |           348,362 |           174,177 |       21.26 |       10.63 |
|   256 |           327,986 |           164,176 |       80.07 |       40.08 |
|   512 |           337,556 |           168,776 |      164.82 |       82.41 |
|  1024 |           320,224 |           160,012 |      312.71 |      156.26 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           210,584 |           104,796 |        3.21 |        1.59 |
|    64 |           200,124 |           100,056 |       12.21 |        6.10 |
|   256 |           210,836 |           105,163 |       51.47 |       25.67 |
|   512 |           253,284 |           126,645 |      123.67 |       61.83 |
|  1024 |           183,602 |            92,140 |      179.29 |       89.98 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           251,470 |           125,717 |        3.83 |        1.91 |
|    64 |           264,320 |           132,159 |       16.13 |        8.06 |
|   256 |           258,938 |           129,480 |       63.21 |       31.61 |
|   512 |           261,306 |           130,668 |      127.59 |       63.80 |
|  1024 |           218,722 |           109,209 |      213.59 |      106.64 |
