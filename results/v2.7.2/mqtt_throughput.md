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

Benchmark results for AWS instance types with LavinMQ version v2.7.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           349,108 |           176,044 |        5.32 |        2.68 |
|    64 |           307,942 |           166,148 |       18.79 |       10.14 |
|   256 |           327,816 |           164,528 |       80.03 |       40.16 |
|   512 |           340,544 |           170,590 |      166.28 |       83.29 |
|  1024 |           282,740 |           140,856 |      276.11 |      137.55 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,498 |           167,752 |        5.11 |        2.55 |
|    64 |           331,202 |           165,537 |       20.21 |       10.10 |
|   256 |           332,502 |           166,455 |       81.17 |       40.63 |
|   512 |           342,770 |           170,922 |      167.36 |       83.45 |
|  1024 |           316,334 |           158,316 |      308.91 |      154.60 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,034 |           172,057 |        5.26 |        2.62 |
|    64 |           351,812 |           202,766 |       21.47 |       12.37 |
|   256 |           350,754 |           180,330 |       85.63 |       44.02 |
|   512 |           289,860 |           145,786 |      141.53 |       71.18 |
|  1024 |           261,940 |           131,417 |      255.80 |      128.33 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,286 |           165,718 |        5.07 |        2.52 |
|    64 |           293,762 |           146,551 |       17.92 |        8.94 |
|   256 |           320,558 |           160,276 |       78.26 |       39.12 |
|   512 |           312,124 |           155,969 |      152.40 |       76.15 |
|  1024 |           313,474 |           156,861 |      306.12 |      153.18 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           327,716 |           163,833 |        5.00 |        2.49 |
|    64 |           333,512 |           166,702 |       20.35 |       10.17 |
|   256 |           305,948 |           153,014 |       74.69 |       37.35 |
|   512 |           270,866 |           135,417 |      132.25 |       66.12 |
|  1024 |           310,082 |           154,607 |      302.81 |      150.98 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,306 |           168,164 |        5.13 |        2.56 |
|    64 |           323,898 |           161,181 |       19.76 |        9.83 |
|   256 |           307,988 |           153,946 |       75.19 |       37.58 |
|   512 |           332,992 |           166,307 |      162.59 |       81.20 |
|  1024 |           298,558 |           149,617 |      291.56 |      146.11 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           320,554 |           160,282 |        4.89 |        2.44 |
|    64 |           318,348 |           159,168 |       19.43 |        9.71 |
|   256 |           323,116 |           161,510 |       78.88 |       39.43 |
|   512 |           321,280 |           160,591 |      156.87 |       78.41 |
|  1024 |           303,782 |           151,631 |      296.66 |      148.07 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           230,066 |           115,159 |        3.51 |        1.75 |
|    64 |           291,346 |           145,203 |       17.78 |        8.86 |
|   256 |           250,672 |           125,073 |       61.19 |       30.53 |
|   512 |           209,852 |           104,698 |      102.46 |       51.12 |
|  1024 |           256,090 |           129,764 |      250.08 |      126.72 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,572 |           166,690 |        5.08 |        2.54 |
|    64 |           274,218 |           136,620 |       16.73 |        8.33 |
|   256 |           333,492 |           166,932 |       81.41 |       40.75 |
|   512 |           326,388 |           163,209 |      159.36 |       79.69 |
|  1024 |           326,984 |           163,894 |      319.32 |      160.05 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           221,332 |           110,639 |        3.37 |        1.68 |
|    64 |           242,726 |           121,177 |       14.81 |        7.39 |
|   256 |           268,000 |           133,593 |       65.42 |       32.61 |
|   512 |           204,940 |           102,376 |      100.06 |       49.98 |
|  1024 |           239,566 |           119,523 |      233.95 |      116.72 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           236,584 |           118,229 |        3.60 |        1.80 |
|    64 |           255,962 |           127,804 |       15.62 |        7.80 |
|   256 |           218,852 |           109,528 |       53.43 |       26.74 |
|   512 |           230,690 |           115,871 |      112.64 |       56.57 |
|  1024 |           255,658 |           127,863 |      249.66 |      124.86 |
