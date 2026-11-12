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

Benchmark results for AWS instance types with LavinMQ version v2.11.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,640 |           168,328 |        5.13 |        2.56 |
|    64 |           342,284 |           171,164 |       20.89 |       10.44 |
|   256 |           344,324 |           170,511 |       84.06 |       41.62 |
|   512 |           350,102 |           176,787 |      170.94 |       86.32 |
|  1024 |           286,806 |           142,552 |      280.08 |      139.21 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,144 |           173,515 |        5.29 |        2.64 |
|    64 |           340,756 |           179,367 |       20.79 |       10.94 |
|   256 |           337,812 |           169,277 |       82.47 |       41.32 |
|   512 |           350,122 |           176,296 |      170.95 |       86.08 |
|  1024 |           289,514 |           144,163 |      282.72 |      140.78 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,256 |           176,924 |        5.35 |        2.69 |
|    64 |           332,316 |           166,948 |       20.28 |       10.18 |
|   256 |           329,034 |           164,545 |       80.33 |       40.17 |
|   512 |           327,680 |           162,615 |      160.00 |       79.40 |
|  1024 |           292,458 |           145,742 |      285.60 |      142.32 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,142 |           170,385 |        5.20 |        2.59 |
|    64 |           339,274 |           169,622 |       20.70 |       10.35 |
|   256 |           327,804 |           164,378 |       80.03 |       40.13 |
|   512 |           326,356 |           163,267 |      159.35 |       79.72 |
|  1024 |           324,790 |           162,415 |      317.17 |      158.60 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           334,396 |           167,138 |        5.10 |        2.55 |
|    64 |           327,852 |           163,902 |       20.01 |       10.00 |
|   256 |           321,430 |           160,703 |       78.47 |       39.23 |
|   512 |           329,914 |           164,973 |      161.09 |       80.55 |
|  1024 |           310,322 |           155,157 |      303.04 |      151.52 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           350,904 |           175,438 |        5.35 |        2.67 |
|    64 |           336,536 |           168,160 |       20.54 |       10.26 |
|   256 |           332,626 |           166,334 |       81.20 |       40.60 |
|   512 |           331,988 |           165,988 |      162.10 |       81.04 |
|  1024 |           325,720 |           162,652 |      318.08 |      158.83 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           338,280 |           169,089 |        5.16 |        2.58 |
|    64 |           330,262 |           165,109 |       20.15 |       10.07 |
|   256 |           329,460 |           164,672 |       80.43 |       40.20 |
|   512 |           322,994 |           161,398 |      157.71 |       78.80 |
|  1024 |           329,460 |           164,728 |      321.73 |      160.86 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           247,690 |           123,981 |        3.77 |        1.89 |
|    64 |           258,876 |           130,439 |       15.80 |        7.96 |
|   256 |           253,258 |           126,582 |       61.83 |       30.90 |
|   512 |           262,332 |           131,567 |      128.09 |       64.24 |
|  1024 |           254,506 |           127,222 |      248.54 |      124.24 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           354,488 |           172,209 |        5.40 |        2.62 |
|    64 |           340,988 |           170,549 |       20.81 |       10.40 |
|   256 |           324,978 |           162,491 |       79.34 |       39.67 |
|   512 |           331,694 |           166,823 |      161.95 |       81.45 |
|  1024 |           313,532 |           156,921 |      306.18 |      153.24 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           250,114 |           125,140 |        3.81 |        1.90 |
|    64 |           252,900 |           126,409 |       15.43 |        7.71 |
|   256 |           253,228 |           126,498 |       61.82 |       30.88 |
|   512 |           237,124 |           117,657 |      115.78 |       57.44 |
|  1024 |           190,698 |            95,265 |      186.22 |       93.03 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           269,494 |           134,722 |        4.11 |        2.05 |
|    64 |           268,176 |           133,885 |       16.36 |        8.17 |
|   256 |           267,622 |           133,844 |       65.33 |       32.67 |
|   512 |           252,512 |           126,259 |      123.29 |       61.64 |
|  1024 |           226,522 |           106,031 |      221.21 |      103.54 |
