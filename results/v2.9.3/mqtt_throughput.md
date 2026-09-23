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

Benchmark results for AWS instance types with LavinMQ version v2.9.3.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,776 |           211,340 |        5.29 |        3.22 |
|    64 |           347,624 |           172,394 |       21.21 |       10.52 |
|   256 |           343,594 |           175,380 |       83.88 |       42.81 |
|   512 |           352,830 |           177,414 |      172.28 |       86.62 |
|  1024 |           287,712 |           143,765 |      280.96 |      140.39 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,408 |           173,046 |        5.16 |        2.64 |
|    64 |           345,870 |           180,861 |       21.11 |       11.03 |
|   256 |           331,242 |           165,611 |       80.86 |       40.43 |
|   512 |           346,848 |           177,593 |      169.35 |       86.71 |
|  1024 |           285,048 |           140,013 |      278.36 |      136.73 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,162 |           236,978 |        5.17 |        3.61 |
|    64 |           351,748 |           191,183 |       21.46 |       11.66 |
|   256 |           337,674 |           171,564 |       82.43 |       41.88 |
|   512 |           336,226 |           166,965 |      164.17 |       81.52 |
|  1024 |           287,598 |           145,530 |      280.85 |      142.11 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,772 |           172,360 |        5.26 |        2.63 |
|    64 |           347,800 |           173,948 |       21.22 |       10.61 |
|   256 |           331,008 |           165,508 |       80.81 |       40.40 |
|   512 |           331,160 |           165,413 |      161.69 |       80.76 |
|  1024 |           332,018 |           166,142 |      324.23 |      162.24 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,222 |           175,094 |        5.34 |        2.67 |
|    64 |           336,490 |           168,232 |       20.53 |       10.26 |
|   256 |           330,418 |           165,205 |       80.66 |       40.33 |
|   512 |           320,354 |           160,066 |      156.42 |       78.15 |
|  1024 |           320,198 |           160,143 |      312.69 |      156.38 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,436 |           169,697 |        5.11 |        2.58 |
|    64 |           337,424 |           169,024 |       20.59 |       10.31 |
|   256 |           320,362 |           160,072 |       78.21 |       39.08 |
|   512 |           328,089 |           164,053 |      160.19 |       80.10 |
|  1024 |           320,036 |           159,998 |      312.53 |      156.24 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,078 |           168,514 |        5.14 |        2.57 |
|    64 |           336,334 |           168,205 |       20.52 |       10.26 |
|   256 |           335,083 |           167,557 |       81.80 |       40.90 |
|   512 |           324,082 |           162,025 |      158.24 |       79.11 |
|  1024 |           328,862 |           164,158 |      321.15 |      160.31 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           214,326 |           107,785 |        3.27 |        1.64 |
|    64 |           227,132 |           112,975 |       13.86 |        6.89 |
|   256 |           174,296 |            87,564 |       42.55 |       21.37 |
|   512 |           183,405 |            91,339 |       89.55 |       44.59 |
|  1024 |           208,460 |           104,288 |      203.57 |      101.84 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,330 |           172,666 |        5.26 |        2.63 |
|    64 |           333,910 |           166,982 |       20.38 |       10.19 |
|   256 |           328,254 |           163,941 |       80.14 |       40.02 |
|   512 |           318,296 |           159,172 |      155.41 |       77.72 |
|  1024 |           329,778 |           164,885 |      322.04 |      161.02 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           221,852 |           111,095 |        3.38 |        1.69 |
|    64 |           254,330 |           127,179 |       15.52 |        7.76 |
|   256 |           271,614 |           135,979 |       66.31 |       33.19 |
|   512 |           194,190 |            97,170 |       94.81 |       47.44 |
|  1024 |           251,034 |           125,788 |      245.15 |      122.83 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           288,890 |           144,474 |        4.40 |        2.20 |
|    64 |           265,094 |           132,289 |       16.18 |        8.07 |
|   256 |           259,870 |           129,881 |       63.44 |       31.70 |
|   512 |           207,972 |           103,970 |      101.54 |       50.76 |
|  1024 |           270,722 |           134,924 |      264.37 |      131.76 |
