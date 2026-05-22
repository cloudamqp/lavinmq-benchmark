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

Benchmark results for AWS instance types with LavinMQ version v2.8.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           356,264 |           179,764 |        5.43 |        2.74 |
|    64 |           352,446 |           183,075 |       21.51 |       11.17 |
|   256 |           338,344 |           170,370 |       82.60 |       41.59 |
|   512 |           349,956 |           175,617 |      170.87 |       85.75 |
|  1024 |           266,674 |           133,336 |      260.42 |      130.21 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,280 |           170,137 |        5.17 |        2.59 |
|    64 |           344,876 |           172,166 |       21.04 |       10.50 |
|   256 |           340,030 |           171,806 |       83.01 |       41.94 |
|   512 |           343,202 |           174,382 |      167.57 |       85.14 |
|  1024 |           279,912 |           140,112 |      273.35 |      136.82 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,074 |           173,794 |        5.28 |        2.65 |
|    64 |           333,088 |           166,662 |       20.33 |       10.17 |
|   256 |           345,830 |           172,572 |       84.43 |       42.13 |
|   512 |           351,882 |           174,678 |      171.81 |       85.29 |
|  1024 |           318,044 |           158,634 |      310.58 |      154.91 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,924 |           167,118 |        5.09 |        2.55 |
|    64 |           321,182 |           161,187 |       19.60 |        9.83 |
|   256 |           315,248 |           157,519 |       76.96 |       38.45 |
|   512 |           314,090 |           157,057 |      153.36 |       76.68 |
|  1024 |           314,874 |           157,505 |      307.49 |      153.81 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,058 |           167,756 |        5.12 |        2.55 |
|    64 |           326,400 |           163,228 |       19.92 |        9.96 |
|   256 |           337,678 |           168,846 |       82.44 |       41.22 |
|   512 |           336,368 |           168,165 |      164.24 |       82.11 |
|  1024 |           325,128 |           162,769 |      317.50 |      158.95 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,952 |           172,506 |        5.26 |        2.63 |
|    64 |           339,354 |           169,666 |       20.71 |       10.35 |
|   256 |           329,206 |           164,569 |       80.37 |       40.17 |
|   512 |           319,208 |           159,660 |      155.86 |       77.95 |
|  1024 |           320,496 |           160,214 |      312.98 |      156.45 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,932 |           172,958 |        5.27 |        2.63 |
|    64 |           328,760 |           164,366 |       20.06 |       10.03 |
|   256 |           329,558 |           164,943 |       80.45 |       40.26 |
|   512 |           327,464 |           163,714 |      159.89 |       79.93 |
|  1024 |           315,814 |           157,918 |      308.41 |      154.21 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           263,122 |           131,553 |        4.01 |        2.00 |
|    64 |           265,446 |           132,699 |       16.20 |        8.09 |
|   256 |           268,676 |           134,002 |       65.59 |       32.71 |
|   512 |           260,142 |           129,800 |      127.02 |       63.37 |
|  1024 |           262,136 |           131,970 |      255.99 |      128.87 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           345,794 |           172,906 |        5.27 |        2.63 |
|    64 |           338,660 |           169,344 |       20.67 |       10.33 |
|   256 |           334,552 |           167,180 |       81.67 |       40.81 |
|   512 |           327,392 |           163,720 |      159.85 |       79.94 |
|  1024 |           329,500 |           164,649 |      321.77 |      160.79 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           249,872 |           124,933 |        3.81 |        1.90 |
|    64 |           202,694 |           102,133 |       12.37 |        6.23 |
|   256 |           195,402 |            97,680 |       47.70 |       23.84 |
|   512 |           203,718 |           101,872 |       99.47 |       49.74 |
|  1024 |           201,612 |           100,784 |      196.88 |       98.42 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           262,176 |           131,130 |        4.00 |        2.00 |
|    64 |           256,092 |           128,059 |       15.63 |        7.81 |
|   256 |           265,970 |           132,969 |       64.93 |       32.46 |
|   512 |           244,534 |           121,756 |      119.40 |       59.45 |
|  1024 |           256,018 |           128,122 |      250.01 |      125.11 |
