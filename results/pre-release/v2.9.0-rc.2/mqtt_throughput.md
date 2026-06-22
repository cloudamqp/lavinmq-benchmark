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

Benchmark results for AWS instance types with LavinMQ version v2.9.0-rc.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           360,598 |           188,835 |        5.50 |        2.88 |
|    64 |           361,586 |           195,168 |       22.06 |       11.91 |
|   256 |           351,976 |           183,825 |       85.93 |       44.87 |
|   512 |           336,318 |           168,294 |      164.21 |       82.17 |
|  1024 |           261,364 |           131,166 |      255.23 |      128.09 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           360,952 |           202,148 |        5.50 |        3.08 |
|    64 |           355,004 |           199,345 |       21.66 |       12.16 |
|   256 |           353,822 |           180,350 |       86.38 |       44.03 |
|   512 |           350,930 |           173,888 |      171.35 |       84.90 |
|  1024 |           240,062 |           120,456 |      234.43 |      117.63 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           325,042 |           162,427 |        4.95 |        2.47 |
|    64 |           365,794 |           215,192 |       22.32 |       13.13 |
|   256 |           340,860 |           170,786 |       83.21 |       41.69 |
|   512 |           343,352 |           171,666 |      167.65 |       83.82 |
|  1024 |           305,400 |           151,956 |      298.24 |      148.39 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           355,574 |           177,863 |        5.42 |        2.71 |
|    64 |           321,388 |           160,714 |       19.61 |        9.80 |
|   256 |           327,232 |           163,570 |       79.89 |       39.93 |
|   512 |           332,293 |           166,397 |      162.25 |       81.24 |
|  1024 |           328,218 |           164,173 |      320.52 |      160.32 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,172 |           173,058 |        5.28 |        2.64 |
|    64 |           311,682 |           155,931 |       19.02 |        9.51 |
|   256 |           328,122 |           164,093 |       80.10 |       40.06 |
|   512 |           315,642 |           157,813 |      154.12 |       77.05 |
|  1024 |           327,328 |           163,667 |      319.65 |      159.83 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,758 |           164,847 |        5.03 |        2.51 |
|    64 |           356,352 |           178,131 |       21.75 |       10.87 |
|   256 |           333,850 |           166,943 |       81.50 |       40.75 |
|   512 |           311,082 |           155,553 |      151.89 |       75.95 |
|  1024 |           320,788 |           160,428 |      313.26 |      156.66 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           344,012 |           172,087 |        5.24 |        2.62 |
|    64 |           345,284 |           172,586 |       21.07 |       10.53 |
|   256 |           341,912 |           170,969 |       83.47 |       41.74 |
|   512 |           331,357 |           165,429 |      161.79 |       80.77 |
|  1024 |           332,814 |           166,398 |      325.01 |      162.49 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           272,370 |           135,987 |        4.15 |        2.07 |
|    64 |           261,620 |           130,804 |       15.96 |        7.98 |
|   256 |           267,932 |           133,957 |       65.41 |       32.70 |
|   512 |           261,114 |           130,741 |      127.49 |       63.83 |
|  1024 |           250,626 |           125,296 |      244.75 |      122.35 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           334,238 |           167,092 |        5.10 |        2.54 |
|    64 |           327,052 |           163,634 |       19.96 |        9.98 |
|   256 |           332,736 |           166,388 |       81.23 |       40.62 |
|   512 |           331,162 |           165,508 |      161.70 |       80.81 |
|  1024 |           318,758 |           159,411 |      311.28 |      155.67 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           262,998 |           132,822 |        4.01 |        2.02 |
|    64 |           209,694 |           104,886 |       12.79 |        6.40 |
|   256 |           201,974 |           101,004 |       49.31 |       24.65 |
|   512 |           191,812 |            95,466 |       93.65 |       46.61 |
|  1024 |           241,886 |           120,968 |      236.21 |      118.13 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           249,654 |           124,716 |        3.80 |        1.90 |
|    64 |           226,602 |           113,473 |       13.83 |        6.92 |
|   256 |           265,666 |           132,848 |       64.85 |       32.43 |
|   512 |           214,942 |           107,479 |      104.95 |       52.47 |
|  1024 |           257,835 |           128,846 |      251.79 |      125.82 |
