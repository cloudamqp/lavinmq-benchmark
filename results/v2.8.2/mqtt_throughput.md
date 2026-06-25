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

Benchmark results for AWS instance types with LavinMQ version v2.8.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,846 |           174,000 |        5.30 |        2.65 |
|    64 |           365,642 |           182,510 |       22.31 |       11.13 |
|   256 |           337,837 |           178,297 |       82.47 |       43.52 |
|   512 |           353,116 |           178,048 |      172.41 |       86.93 |
|  1024 |           291,104 |           145,566 |      284.28 |      142.15 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           368,282 |           202,409 |        5.61 |        3.08 |
|    64 |           353,906 |           178,163 |       21.60 |       10.87 |
|   256 |           335,850 |           167,994 |       81.99 |       41.01 |
|   512 |           346,328 |           174,135 |      169.10 |       85.02 |
|  1024 |           256,892 |           128,376 |      250.87 |      125.36 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,470 |           172,062 |        5.25 |        2.62 |
|    64 |           353,146 |           176,490 |       21.55 |       10.77 |
|   256 |           344,972 |           175,750 |       84.22 |       42.90 |
|   512 |           350,470 |           175,269 |      171.12 |       85.58 |
|  1024 |           280,976 |           140,277 |      274.39 |      136.98 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,850 |           168,913 |        5.15 |        2.57 |
|    64 |           342,100 |           171,036 |       20.88 |       10.43 |
|   256 |           337,474 |           169,005 |       82.39 |       41.26 |
|   512 |           327,304 |           163,638 |      159.81 |       79.90 |
|  1024 |           346,432 |           173,250 |      338.31 |      169.18 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,290 |           166,657 |        5.07 |        2.54 |
|    64 |           321,886 |           160,644 |       19.64 |        9.80 |
|   256 |           326,950 |           163,333 |       79.82 |       39.87 |
|   512 |           308,094 |           153,991 |      150.43 |       75.19 |
|  1024 |           312,224 |           155,613 |      304.90 |      151.96 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,978 |           172,769 |        5.27 |        2.63 |
|    64 |           320,078 |           160,094 |       19.53 |        9.77 |
|   256 |           327,930 |           163,657 |       80.06 |       39.95 |
|   512 |           313,416 |           156,904 |      153.03 |       76.61 |
|  1024 |           320,976 |           160,323 |      313.45 |      156.56 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,288 |           171,620 |        5.23 |        2.61 |
|    64 |           327,878 |           164,087 |       20.01 |       10.01 |
|   256 |           338,202 |           169,071 |       82.56 |       41.27 |
|   512 |           327,326 |           163,577 |      159.82 |       79.87 |
|  1024 |           319,524 |           159,763 |      312.03 |      156.01 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           251,526 |           125,729 |        3.83 |        1.91 |
|    64 |           268,396 |           134,204 |       16.38 |        8.19 |
|   256 |           267,450 |           133,646 |       65.29 |       32.62 |
|   512 |           251,442 |           125,758 |      122.77 |       61.40 |
|  1024 |           257,030 |           128,530 |      251.00 |      125.51 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,766 |           170,918 |        5.21 |        2.60 |
|    64 |           346,408 |           173,174 |       21.14 |       10.56 |
|   256 |           335,392 |           167,531 |       81.88 |       40.90 |
|   512 |           329,110 |           164,584 |      160.69 |       80.36 |
|  1024 |           326,754 |           163,353 |      319.09 |      159.52 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           264,300 |           132,397 |        4.03 |        2.02 |
|    64 |           198,470 |            99,216 |       12.11 |        6.05 |
|   256 |           243,716 |           121,102 |       59.50 |       29.56 |
|   512 |           194,776 |            97,286 |       95.10 |       47.50 |
|  1024 |           254,032 |           126,846 |      248.07 |      123.87 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           272,882 |           136,810 |        4.16 |        2.08 |
|    64 |           264,316 |           132,003 |       16.13 |        8.05 |
|   256 |           269,652 |           134,550 |       65.83 |       32.84 |
|   512 |           257,736 |           129,302 |      125.84 |       63.13 |
|  1024 |           239,280 |           119,634 |      233.67 |      116.83 |
