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

Benchmark results for AWS instance types with LavinMQ version v2.9.0-rc.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,314 |           172,730 |        5.17 |        2.63 |
|    64 |           364,016 |           195,920 |       22.21 |       11.95 |
|   256 |           335,636 |           174,379 |       81.94 |       42.57 |
|   512 |           339,620 |           169,323 |      165.83 |       82.67 |
|  1024 |           284,630 |           143,018 |      277.95 |      139.66 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,180 |           174,124 |        5.31 |        2.65 |
|    64 |           343,118 |           171,545 |       20.94 |       10.47 |
|   256 |           335,524 |           167,398 |       81.91 |       40.86 |
|   512 |           360,936 |           180,100 |      176.23 |       87.93 |
|  1024 |           336,378 |           168,119 |      328.49 |      164.17 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           352,288 |           176,008 |        5.37 |        2.68 |
|    64 |           345,614 |           199,732 |       21.09 |       12.19 |
|   256 |           337,460 |           166,933 |       82.38 |       40.75 |
|   512 |           343,424 |           172,142 |      167.68 |       84.05 |
|  1024 |           302,428 |           151,092 |      295.33 |      147.55 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,968 |           173,546 |        5.29 |        2.64 |
|    64 |           341,856 |           170,944 |       20.86 |       10.43 |
|   256 |           324,552 |           162,224 |       79.23 |       39.60 |
|   512 |           320,992 |           160,645 |      156.73 |       78.43 |
|  1024 |           322,554 |           161,095 |      314.99 |      157.31 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,751 |           169,914 |        5.18 |        2.59 |
|    64 |           333,866 |           166,976 |       20.37 |       10.19 |
|   256 |           320,320 |           160,158 |       78.20 |       39.10 |
|   512 |           329,640 |           165,058 |      160.95 |       80.59 |
|  1024 |           330,882 |           165,762 |      323.12 |      161.87 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,450 |           175,712 |        5.36 |        2.68 |
|    64 |           347,254 |           173,613 |       21.19 |       10.59 |
|   256 |           333,352 |           166,681 |       81.38 |       40.69 |
|   512 |           325,738 |           162,635 |      159.05 |       79.41 |
|  1024 |           325,818 |           162,910 |      318.18 |      159.09 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           346,739 |           173,041 |        5.29 |        2.64 |
|    64 |           340,878 |           170,405 |       20.80 |       10.40 |
|   256 |           336,802 |           168,549 |       82.22 |       41.14 |
|   512 |           322,720 |           161,365 |      157.57 |       78.79 |
|  1024 |           322,768 |           161,376 |      315.20 |      157.59 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           254,446 |           126,762 |        3.88 |        1.93 |
|    64 |           259,458 |           129,830 |       15.83 |        7.92 |
|   256 |           253,356 |           126,985 |       61.85 |       31.00 |
|   512 |           264,622 |           131,735 |      129.20 |       64.32 |
|  1024 |           247,940 |           123,991 |      242.12 |      121.08 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,230 |           173,613 |        5.29 |        2.64 |
|    64 |           342,430 |           171,149 |       20.90 |       10.44 |
|   256 |           314,846 |           157,324 |       76.86 |       38.40 |
|   512 |           322,824 |           161,538 |      157.62 |       78.87 |
|  1024 |           321,610 |           160,772 |      314.07 |      157.00 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           267,786 |           133,614 |        4.08 |        2.03 |
|    64 |           278,034 |           138,998 |       16.96 |        8.48 |
|   256 |           242,196 |           120,999 |       59.12 |       29.54 |
|   512 |           253,192 |           126,600 |      123.62 |       61.81 |
|  1024 |           267,310 |           133,714 |      261.04 |      130.58 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           266,300 |           133,221 |        4.06 |        2.03 |
|    64 |           270,173 |           135,451 |       16.49 |        8.26 |
|   256 |           282,337 |           140,673 |       68.92 |       34.34 |
|   512 |           212,298 |           106,448 |      103.66 |       51.97 |
|  1024 |           222,138 |           110,676 |      216.93 |      108.08 |
