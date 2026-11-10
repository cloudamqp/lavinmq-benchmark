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

Benchmark results for AWS instance types with LavinMQ version v2.10.5.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           327,012 |           163,246 |        4.98 |        2.49 |
|    64 |           329,464 |           164,725 |       20.10 |       10.05 |
|   256 |           332,900 |           169,659 |       81.27 |       41.42 |
|   512 |           333,362 |           164,749 |      162.77 |       80.44 |
|  1024 |           284,910 |           142,506 |      278.23 |      139.16 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           328,994 |           164,039 |        5.02 |        2.50 |
|    64 |           336,326 |           168,397 |       20.52 |       10.27 |
|   256 |           325,750 |           162,790 |       79.52 |       39.74 |
|   512 |           344,224 |           177,107 |      168.07 |       86.47 |
|  1024 |           311,714 |           155,775 |      304.40 |      152.12 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,626 |           177,011 |        5.28 |        2.70 |
|    64 |           360,648 |           211,153 |       22.01 |       12.88 |
|   256 |           340,476 |           170,138 |       83.12 |       41.53 |
|   512 |           339,272 |           166,604 |      165.66 |       81.34 |
|  1024 |           275,048 |           137,970 |      268.60 |      134.73 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,498 |           168,756 |        5.14 |        2.57 |
|    64 |           329,976 |           165,013 |       20.14 |       10.07 |
|   256 |           325,982 |           162,995 |       79.58 |       39.79 |
|   512 |           337,926 |           169,094 |      165.00 |       82.56 |
|  1024 |           317,500 |           158,784 |      310.05 |      155.06 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,838 |           173,299 |        5.29 |        2.64 |
|    64 |           337,064 |           168,579 |       20.57 |       10.28 |
|   256 |           336,168 |           168,154 |       82.07 |       41.05 |
|   512 |           334,764 |           167,471 |      163.45 |       81.77 |
|  1024 |           326,608 |           163,291 |      318.95 |      159.46 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           349,966 |           175,000 |        5.34 |        2.67 |
|    64 |           322,170 |           161,062 |       19.66 |        9.83 |
|   256 |           330,404 |           165,191 |       80.66 |       40.32 |
|   512 |           322,104 |           161,261 |      157.27 |       78.74 |
|  1024 |           314,062 |           156,923 |      306.70 |      153.24 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,828 |           168,472 |        5.13 |        2.57 |
|    64 |           337,604 |           168,796 |       20.60 |       10.30 |
|   256 |           331,794 |           165,886 |       81.00 |       40.49 |
|   512 |           330,884 |           165,425 |      161.56 |       80.77 |
|  1024 |           326,280 |           162,437 |      318.63 |      158.62 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           195,818 |            97,232 |        2.98 |        1.48 |
|    64 |           259,314 |           129,772 |       15.82 |        7.92 |
|   256 |           178,716 |            89,865 |       43.63 |       21.93 |
|   512 |           247,188 |           123,889 |      120.69 |       60.49 |
|  1024 |           181,236 |            93,136 |      176.98 |       90.95 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,428 |           175,702 |        5.36 |        2.68 |
|    64 |           335,790 |           167,898 |       20.49 |       10.24 |
|   256 |           321,230 |           160,702 |       78.42 |       39.23 |
|   512 |           321,422 |           160,741 |      156.94 |       78.48 |
|  1024 |           321,208 |           160,588 |      313.67 |      156.82 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           189,348 |            94,574 |        2.88 |        1.44 |
|    64 |           196,652 |            98,714 |       12.00 |        6.02 |
|   256 |           179,160 |            89,515 |       43.74 |       21.85 |
|   512 |           174,746 |            87,554 |       85.32 |       42.75 |
|  1024 |           161,804 |            80,911 |      158.01 |       79.01 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           269,602 |           134,801 |        4.11 |        2.05 |
|    64 |           249,506 |           124,735 |       15.22 |        7.61 |
|   256 |           261,188 |           130,600 |       63.76 |       31.88 |
|   512 |           258,528 |           129,225 |      126.23 |       63.09 |
|  1024 |           258,326 |           129,137 |      252.27 |      126.11 |
