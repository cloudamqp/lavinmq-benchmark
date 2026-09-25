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

Benchmark results for AWS instance types with LavinMQ version v2.10.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           331,610 |           172,726 |        5.05 |        2.63 |
|    64 |           329,602 |           164,829 |       20.11 |       10.06 |
|   256 |           335,964 |           178,394 |       82.02 |       43.55 |
|   512 |           336,974 |           168,364 |      164.53 |       82.20 |
|  1024 |           325,682 |           161,177 |      318.04 |      157.39 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,480 |           192,794 |        5.19 |        2.94 |
|    64 |           333,730 |           172,369 |       20.36 |       10.52 |
|   256 |           342,674 |           169,454 |       83.66 |       41.37 |
|   512 |           335,214 |           171,732 |      163.67 |       83.85 |
|  1024 |           334,624 |           167,454 |      326.78 |      163.52 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           352,918 |           176,255 |        5.38 |        2.68 |
|    64 |           346,540 |           172,253 |       21.15 |       10.51 |
|   256 |           321,074 |           160,735 |       78.38 |       39.24 |
|   512 |           332,694 |           168,298 |      162.44 |       82.17 |
|  1024 |           325,992 |           162,641 |      318.35 |      158.82 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           342,768 |           171,273 |        5.23 |        2.61 |
|    64 |           338,754 |           169,467 |       20.67 |       10.34 |
|   256 |           337,180 |           167,563 |       82.31 |       40.90 |
|   512 |           330,410 |           164,885 |      161.33 |       80.51 |
|  1024 |           325,244 |           162,492 |      317.62 |      158.68 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,382 |           166,682 |        5.08 |        2.54 |
|    64 |           335,854 |           167,960 |       20.49 |       10.25 |
|   256 |           328,956 |           164,463 |       80.31 |       40.15 |
|   512 |           332,572 |           165,904 |      162.38 |       81.00 |
|  1024 |           325,134 |           162,556 |      317.51 |      158.74 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           303,328 |           151,704 |        4.62 |        2.31 |
|    64 |           315,866 |           158,129 |       19.27 |        9.65 |
|   256 |           326,278 |           163,455 |       79.65 |       39.90 |
|   512 |           322,178 |           161,113 |      157.31 |       78.66 |
|  1024 |           307,368 |           153,850 |      300.16 |      150.24 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,346 |           170,671 |        5.20 |        2.60 |
|    64 |           347,676 |           173,752 |       21.22 |       10.60 |
|   256 |           335,604 |           167,889 |       81.93 |       40.98 |
|   512 |           327,846 |           163,893 |      160.08 |       80.02 |
|  1024 |           321,592 |           160,787 |      314.05 |      157.01 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           265,202 |           133,117 |        4.04 |        2.03 |
|    64 |           272,128 |           136,282 |       16.60 |        8.31 |
|   256 |           248,990 |           124,798 |       60.78 |       30.46 |
|   512 |           213,614 |           106,466 |      104.30 |       51.98 |
|  1024 |           245,368 |           122,491 |      239.61 |      119.62 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,264 |           169,867 |        5.17 |        2.59 |
|    64 |           333,940 |           166,944 |       20.38 |       10.18 |
|   256 |           327,737 |           163,809 |       80.01 |       39.99 |
|   512 |           318,470 |           159,417 |      155.50 |       77.84 |
|  1024 |           322,095 |           160,872 |      314.54 |      157.10 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           287,966 |           144,192 |        4.39 |        2.20 |
|    64 |           196,360 |            98,145 |       11.98 |        5.99 |
|   256 |           260,460 |           130,126 |       63.58 |       31.76 |
|   512 |           198,331 |            91,635 |       96.84 |       44.74 |
|  1024 |           250,500 |           125,803 |      244.62 |      122.85 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           279,990 |           139,984 |        4.27 |        2.13 |
|    64 |           268,386 |           134,187 |       16.38 |        8.19 |
|   256 |           243,316 |           122,109 |       59.40 |       29.81 |
|   512 |           256,480 |           128,019 |      125.23 |       62.50 |
|  1024 |           261,872 |           130,970 |      255.73 |      127.90 |
