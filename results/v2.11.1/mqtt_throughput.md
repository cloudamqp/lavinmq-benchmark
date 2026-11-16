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

Benchmark results for AWS instance types with LavinMQ version v2.11.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,048 |           182,589 |        5.29 |        2.78 |
|    64 |           345,632 |           177,543 |       21.09 |       10.83 |
|   256 |           328,302 |           166,098 |       80.15 |       40.55 |
|   512 |           341,292 |           177,556 |      166.64 |       86.69 |
|  1024 |           264,202 |           132,105 |      258.00 |      129.00 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,428 |           181,858 |        5.28 |        2.77 |
|    64 |           344,220 |           174,725 |       21.00 |       10.66 |
|   256 |           339,160 |           179,580 |       82.80 |       43.84 |
|   512 |           342,030 |           172,968 |      167.00 |       84.45 |
|  1024 |           272,506 |           136,683 |      266.11 |      133.47 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,184 |           168,580 |        5.14 |        2.57 |
|    64 |           334,542 |           167,208 |       20.41 |       10.20 |
|   256 |           334,292 |           167,194 |       81.61 |       40.81 |
|   512 |           344,764 |           174,206 |      168.34 |       85.06 |
|  1024 |           295,070 |           146,563 |      288.15 |      143.12 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,090 |           171,792 |        5.23 |        2.62 |
|    64 |           345,463 |           173,963 |       21.08 |       10.61 |
|   256 |           325,510 |           162,761 |       79.47 |       39.73 |
|   512 |           336,718 |           168,432 |      164.41 |       82.24 |
|  1024 |           335,906 |           166,937 |      328.03 |      163.02 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,662 |           168,556 |        5.15 |        2.57 |
|    64 |           335,966 |           167,968 |       20.50 |       10.25 |
|   256 |           333,076 |           166,573 |       81.31 |       40.66 |
|   512 |           332,216 |           165,949 |      162.21 |       81.02 |
|  1024 |           332,064 |           165,329 |      324.28 |      161.45 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,920 |           176,208 |        5.36 |        2.68 |
|    64 |           333,688 |           166,831 |       20.36 |       10.18 |
|   256 |           329,482 |           164,818 |       80.43 |       40.23 |
|   512 |           325,220 |           162,578 |      158.79 |       79.38 |
|  1024 |           322,203 |           161,150 |      314.65 |      157.37 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,888 |           156,626 |        5.03 |        2.38 |
|    64 |           332,218 |           165,932 |       20.27 |       10.12 |
|   256 |           321,230 |           160,482 |       78.42 |       39.18 |
|   512 |           316,756 |           158,430 |      154.66 |       77.35 |
|  1024 |           321,342 |           160,620 |      313.81 |      156.85 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           268,558 |           134,309 |        4.09 |        2.04 |
|    64 |           287,552 |           143,801 |       17.55 |        8.77 |
|   256 |           254,874 |           127,442 |       62.22 |       31.11 |
|   512 |           247,014 |           123,690 |      120.61 |       60.39 |
|  1024 |           238,744 |           119,371 |      233.14 |      116.57 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,334 |           173,742 |        5.29 |        2.65 |
|    64 |           315,582 |           157,755 |       19.26 |        9.62 |
|   256 |           326,702 |           163,352 |       79.76 |       39.88 |
|   512 |           326,504 |           163,265 |      159.42 |       79.71 |
|  1024 |           315,704 |           157,878 |      308.30 |      154.17 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           275,502 |           137,554 |        4.20 |        2.09 |
|    64 |           251,774 |           125,794 |       15.36 |        7.67 |
|   256 |           248,286 |           124,279 |       60.61 |       30.34 |
|   512 |           240,466 |           120,396 |      117.41 |       58.78 |
|  1024 |           289,384 |           144,709 |      282.60 |      141.31 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,008 |           134,842 |        4.11 |        2.05 |
|    64 |           273,579 |           136,700 |       16.69 |        8.34 |
|   256 |           266,908 |           133,442 |       65.16 |       32.57 |
|   512 |           272,794 |           136,368 |      133.20 |       66.58 |
|  1024 |           249,504 |           124,856 |      243.65 |      121.92 |
