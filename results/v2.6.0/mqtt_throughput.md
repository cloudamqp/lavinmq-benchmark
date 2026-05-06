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

Benchmark results for AWS instance types with LavinMQ version v2.6.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,808 |           172,836 |        5.27 |        2.63 |
|    64 |           358,504 |           190,223 |       21.88 |       11.61 |
|   256 |           339,354 |           173,374 |       82.85 |       42.32 |
|   512 |           340,556 |           172,654 |      166.28 |       84.30 |
|  1024 |           269,660 |           135,198 |      263.33 |      132.02 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,604 |           175,600 |        5.36 |        2.67 |
|    64 |           362,774 |           182,926 |       22.14 |       11.16 |
|   256 |           338,474 |           169,789 |       82.63 |       41.45 |
|   512 |           340,480 |           169,936 |      166.25 |       82.97 |
|  1024 |           269,292 |           134,258 |      262.98 |      131.11 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,396 |           178,687 |        5.31 |        2.72 |
|    64 |           349,630 |           175,748 |       21.33 |       10.72 |
|   256 |           340,944 |           173,752 |       83.23 |       42.41 |
|   512 |           352,018 |           176,006 |      171.88 |       85.94 |
|  1024 |           262,534 |           131,232 |      256.38 |      128.15 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           306,453 |           136,247 |        4.67 |        2.07 |
|    64 |           345,442 |           172,668 |       21.08 |       10.53 |
|   256 |           345,592 |           172,791 |       84.37 |       42.18 |
|   512 |           322,366 |           161,082 |      157.40 |       78.65 |
|  1024 |           334,022 |           167,205 |      326.19 |      163.28 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           331,094 |           165,608 |        5.05 |        2.52 |
|    64 |           328,218 |           164,060 |       20.03 |       10.01 |
|   256 |           320,724 |           160,487 |       78.30 |       39.18 |
|   512 |           321,340 |           160,642 |      156.90 |       78.43 |
|  1024 |           297,934 |           149,130 |      290.95 |      145.63 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,178 |           166,075 |        5.06 |        2.53 |
|    64 |           336,090 |           168,052 |       20.51 |       10.25 |
|   256 |           348,532 |           174,329 |       85.09 |       42.56 |
|   512 |           348,786 |           174,093 |      170.30 |       85.00 |
|  1024 |           333,858 |           166,940 |      326.03 |      163.02 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           334,590 |           167,352 |        5.10 |        2.55 |
|    64 |           344,702 |           172,340 |       21.03 |       10.51 |
|   256 |           311,206 |           155,622 |       75.97 |       37.99 |
|   512 |           330,894 |           165,448 |      161.56 |       80.78 |
|  1024 |           324,274 |           162,105 |      316.67 |      158.30 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           266,830 |           133,346 |        4.07 |        2.03 |
|    64 |           278,466 |           139,297 |       16.99 |        8.50 |
|   256 |           261,638 |           131,223 |       63.87 |       32.03 |
|   512 |           274,398 |           137,376 |      133.98 |       67.07 |
|  1024 |           209,372 |           104,666 |      204.46 |      102.21 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           343,916 |           171,958 |        5.24 |        2.62 |
|    64 |           340,840 |           170,402 |       20.80 |       10.40 |
|   256 |           341,900 |           170,918 |       83.47 |       41.72 |
|   512 |           341,618 |           170,818 |      166.80 |       83.40 |
|  1024 |           336,488 |           168,236 |      328.60 |      164.29 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           247,082 |           123,594 |        3.77 |        1.88 |
|    64 |           212,578 |           106,604 |       12.97 |        6.50 |
|   256 |           245,718 |           121,877 |       59.98 |       29.75 |
|   512 |           243,298 |           121,392 |      118.79 |       59.27 |
|  1024 |           254,984 |           127,497 |      249.00 |      124.50 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,540 |           135,683 |        4.12 |        2.07 |
|    64 |           260,392 |           130,603 |       15.89 |        7.97 |
|   256 |           258,918 |           129,403 |       63.21 |       31.59 |
|   512 |           224,542 |           112,557 |      109.63 |       54.95 |
|  1024 |           265,218 |           132,937 |      259.00 |      129.82 |
