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

Benchmark results for AWS instance types with LavinMQ version v2.10.4.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,070 |           169,042 |        5.15 |        2.57 |
|    64 |           337,296 |           168,629 |       20.58 |       10.29 |
|   256 |           359,088 |           182,752 |       87.66 |       44.61 |
|   512 |           336,702 |           168,604 |      164.40 |       82.32 |
|  1024 |           328,224 |           166,695 |      320.53 |      162.78 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,124 |           175,387 |        5.34 |        2.67 |
|    64 |           349,492 |           197,056 |       21.33 |       12.02 |
|   256 |           336,958 |           173,316 |       82.26 |       42.31 |
|   512 |           351,130 |           176,257 |      171.45 |       86.06 |
|  1024 |           292,454 |           145,530 |      285.59 |      142.11 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,924 |           169,959 |        5.18 |        2.59 |
|    64 |           340,152 |           179,935 |       20.76 |       10.98 |
|   256 |           319,900 |           164,333 |       78.10 |       40.12 |
|   512 |           325,772 |           164,045 |      159.06 |       80.10 |
|  1024 |           277,166 |           137,213 |      270.66 |      133.99 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,474 |           164,758 |        5.02 |        2.51 |
|    64 |           342,842 |           171,599 |       20.92 |       10.47 |
|   256 |           335,712 |           167,820 |       81.96 |       40.97 |
|   512 |           321,424 |           160,744 |      156.94 |       78.48 |
|  1024 |           322,788 |           161,339 |      315.22 |      157.55 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           331,948 |           165,959 |        5.06 |        2.53 |
|    64 |           343,266 |           171,677 |       20.95 |       10.47 |
|   256 |           317,338 |           158,807 |       77.47 |       38.77 |
|   512 |           320,004 |           159,988 |      156.25 |       78.11 |
|  1024 |           315,174 |           157,639 |      307.78 |      153.94 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,494 |           171,037 |        5.21 |        2.60 |
|    64 |           328,650 |           164,215 |       20.05 |       10.02 |
|   256 |           326,622 |           163,655 |       79.74 |       39.95 |
|   512 |           323,602 |           161,785 |      158.00 |       78.99 |
|  1024 |           327,284 |           163,695 |      319.61 |      159.85 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,910 |           169,507 |        5.17 |        2.58 |
|    64 |           337,978 |           168,729 |       20.62 |       10.29 |
|   256 |           333,580 |           166,793 |       81.44 |       40.72 |
|   512 |           327,026 |           163,504 |      159.68 |       79.83 |
|  1024 |           320,726 |           160,392 |      313.20 |      156.63 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           198,090 |            98,905 |        3.02 |        1.50 |
|    64 |           200,664 |           100,244 |       12.24 |        6.11 |
|   256 |           218,360 |           109,127 |       53.31 |       26.64 |
|   512 |           242,600 |           121,371 |      118.45 |       59.26 |
|  1024 |           242,992 |           121,261 |      237.29 |      118.41 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,472 |           166,686 |        5.08 |        2.54 |
|    64 |           332,032 |           166,018 |       20.26 |       10.13 |
|   256 |           330,124 |           165,013 |       80.59 |       40.28 |
|   512 |           309,662 |           155,030 |      151.20 |       75.69 |
|  1024 |           316,620 |           158,253 |      309.19 |      154.54 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           257,194 |           128,775 |        3.92 |        1.96 |
|    64 |           266,134 |           133,093 |       16.24 |        8.12 |
|   256 |           174,638 |            87,341 |       42.63 |       21.32 |
|   512 |           274,396 |           137,179 |      133.98 |       66.98 |
|  1024 |           241,912 |           120,915 |      236.24 |      118.08 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           281,846 |           140,913 |        4.30 |        2.15 |
|    64 |           284,220 |           142,025 |       17.34 |        8.66 |
|   256 |           261,576 |           130,776 |       63.86 |       31.92 |
|   512 |           215,790 |           107,823 |      105.36 |       52.64 |
|  1024 |           220,534 |           110,281 |      215.36 |      107.69 |
