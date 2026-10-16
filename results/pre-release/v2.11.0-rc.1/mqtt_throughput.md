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

Benchmark results for AWS instance types with LavinMQ version v2.11.0-rc.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,182 |           171,309 |        5.22 |        2.61 |
|    64 |           339,786 |           174,672 |       20.73 |       10.66 |
|   256 |           332,234 |           168,581 |       81.11 |       41.15 |
|   512 |           325,122 |           166,919 |      158.75 |       81.50 |
|  1024 |           237,346 |           118,818 |      231.78 |      116.03 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,856 |           176,440 |        5.17 |        2.69 |
|    64 |           339,724 |           170,992 |       20.73 |       10.43 |
|   256 |           347,270 |           181,450 |       84.78 |       44.29 |
|   512 |           336,604 |           166,116 |      164.35 |       81.11 |
|  1024 |           255,682 |           128,000 |      249.68 |      125.00 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,256 |           170,684 |        5.23 |        2.60 |
|    64 |           327,290 |           163,796 |       19.97 |        9.99 |
|   256 |           324,140 |           162,213 |       79.13 |       39.60 |
|   512 |           339,842 |           162,613 |      165.93 |       79.40 |
|  1024 |           253,720 |           127,287 |      247.77 |      124.30 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,002 |           164,517 |        5.02 |        2.51 |
|    64 |           320,792 |           160,362 |       19.57 |        9.78 |
|   256 |           327,008 |           163,499 |       79.83 |       39.91 |
|   512 |           320,042 |           160,044 |      156.27 |       78.14 |
|  1024 |           312,905 |           156,460 |      305.57 |      152.79 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           330,464 |           165,279 |        5.04 |        2.52 |
|    64 |           344,918 |           172,404 |       21.05 |       10.52 |
|   256 |           314,018 |           157,041 |       76.66 |       38.34 |
|   512 |           316,370 |           158,233 |      154.47 |       77.26 |
|  1024 |           329,594 |           164,727 |      321.86 |      160.86 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,022 |           171,515 |        5.23 |        2.61 |
|    64 |           341,636 |           170,810 |       20.85 |       10.42 |
|   256 |           323,502 |           161,869 |       78.97 |       39.51 |
|   512 |           313,464 |           156,669 |      153.05 |       76.49 |
|  1024 |           314,334 |           157,177 |      306.96 |      153.49 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           325,674 |           162,920 |        4.96 |        2.48 |
|    64 |           316,892 |           158,546 |       19.34 |        9.67 |
|   256 |           329,440 |           164,627 |       80.42 |       40.19 |
|   512 |           331,352 |           165,708 |      161.79 |       80.91 |
|  1024 |           324,176 |           162,036 |      316.57 |      158.23 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           261,752 |           131,542 |        3.99 |        2.00 |
|    64 |           266,354 |           133,165 |       16.25 |        8.12 |
|   256 |           256,348 |           128,178 |       62.58 |       31.29 |
|   512 |           209,173 |           104,854 |      102.13 |       51.19 |
|  1024 |           254,902 |           127,914 |      248.92 |      124.91 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,380 |           172,697 |        5.27 |        2.63 |
|    64 |           343,464 |           171,730 |       20.96 |       10.48 |
|   256 |           333,886 |           166,977 |       81.51 |       40.76 |
|   512 |           333,750 |           166,673 |      162.96 |       81.38 |
|  1024 |           324,818 |           162,360 |      317.20 |      158.55 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,472 |           135,255 |        4.12 |        2.06 |
|    64 |           213,374 |           106,848 |       13.02 |        6.52 |
|   256 |           274,106 |           137,029 |       66.92 |       33.45 |
|   512 |           257,232 |           128,567 |      125.60 |       62.77 |
|  1024 |           256,416 |           128,483 |      250.40 |      125.47 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           257,582 |           128,782 |        3.93 |        1.96 |
|    64 |           268,574 |           134,324 |       16.39 |        8.19 |
|   256 |           232,612 |           116,399 |       56.79 |       28.41 |
|   512 |           273,300 |           136,285 |      133.44 |       66.54 |
|  1024 |           249,992 |           125,063 |      244.13 |      122.13 |
