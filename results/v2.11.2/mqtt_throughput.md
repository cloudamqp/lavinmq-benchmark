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

Benchmark results for AWS instance types with LavinMQ version v2.11.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,398 |           173,072 |        5.14 |        2.64 |
|    64 |           321,852 |           160,977 |       19.64 |        9.82 |
|   256 |           337,424 |           170,332 |       82.37 |       41.58 |
|   512 |           350,460 |           177,099 |      171.12 |       86.47 |
|  1024 |           303,244 |           152,052 |      296.13 |      148.48 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,706 |           169,280 |        5.15 |        2.58 |
|    64 |           336,676 |           168,300 |       20.54 |       10.27 |
|   256 |           341,572 |           171,828 |       83.39 |       41.95 |
|   512 |           346,188 |           171,926 |      169.03 |       83.94 |
|  1024 |           287,476 |           143,907 |      280.73 |      140.53 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,936 |           174,011 |        5.20 |        2.65 |
|    64 |           334,684 |           172,376 |       20.42 |       10.52 |
|   256 |           333,280 |           169,685 |       81.36 |       41.42 |
|   512 |           340,342 |           170,924 |      166.18 |       83.45 |
|  1024 |           266,982 |           133,613 |      260.72 |      130.48 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           324,128 |           162,079 |        4.94 |        2.47 |
|    64 |           334,664 |           167,334 |       20.42 |       10.21 |
|   256 |           324,924 |           162,401 |       79.32 |       39.64 |
|   512 |           320,574 |           160,417 |      156.53 |       78.32 |
|  1024 |           317,242 |           158,735 |      309.80 |      155.01 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,316 |           169,419 |        5.16 |        2.58 |
|    64 |           329,664 |           164,896 |       20.12 |       10.06 |
|   256 |           311,498 |           155,688 |       76.04 |       38.00 |
|   512 |           329,448 |           164,770 |      160.86 |       80.45 |
|  1024 |           300,066 |           150,073 |      293.03 |      146.55 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,098 |           167,603 |        5.11 |        2.55 |
|    64 |           337,908 |           168,966 |       20.62 |       10.31 |
|   256 |           329,120 |           164,597 |       80.35 |       40.18 |
|   512 |           318,158 |           159,095 |      155.35 |       77.68 |
|  1024 |           320,994 |           160,236 |      313.47 |      156.48 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           328,858 |           164,560 |        5.01 |        2.51 |
|    64 |           326,262 |           161,834 |       19.91 |        9.87 |
|   256 |           335,414 |           167,595 |       81.88 |       40.91 |
|   512 |           313,924 |           157,273 |      153.28 |       76.79 |
|  1024 |           307,624 |           153,804 |      300.41 |      150.19 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           178,256 |            89,129 |        2.71 |        1.36 |
|    64 |           206,886 |           103,420 |       12.62 |        6.31 |
|   256 |           256,490 |           128,222 |       62.61 |       31.30 |
|   512 |           205,792 |           102,942 |      100.48 |       50.26 |
|  1024 |           247,952 |           124,008 |      242.14 |      121.10 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           325,368 |           162,605 |        4.96 |        2.48 |
|    64 |           315,528 |           157,790 |       19.25 |        9.63 |
|   256 |           290,216 |           145,073 |       70.85 |       35.41 |
|   512 |           298,914 |           149,507 |      145.95 |       73.00 |
|  1024 |           281,500 |           140,757 |      274.90 |      137.45 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           201,956 |           101,473 |        3.08 |        1.54 |
|    64 |           170,890 |            85,435 |       10.43 |        5.21 |
|   256 |           212,144 |           106,062 |       51.79 |       25.89 |
|   512 |           269,878 |           134,867 |      131.77 |       65.85 |
|  1024 |           243,662 |           119,800 |      237.95 |      116.99 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           256,964 |           128,715 |        3.92 |        1.96 |
|    64 |           260,442 |           130,365 |       15.89 |        7.95 |
|   256 |           251,008 |           125,495 |       61.28 |       30.63 |
|   512 |           249,406 |           124,717 |      121.78 |       60.89 |
|  1024 |           281,226 |           140,536 |      274.63 |      137.24 |
