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

Benchmark results for AWS instance types with LavinMQ version v2.10.0-rc.1.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,278 |           185,988 |        5.29 |        2.83 |
|    64 |           329,924 |           186,785 |       20.13 |       11.40 |
|   256 |           340,822 |           178,079 |       83.20 |       43.47 |
|   512 |           343,704 |           175,338 |      167.82 |       85.61 |
|  1024 |           277,986 |           138,861 |      271.47 |      135.60 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           351,806 |           222,469 |        5.36 |        3.39 |
|    64 |           361,172 |           227,520 |       22.04 |       13.88 |
|   256 |           336,432 |           168,014 |       82.13 |       41.01 |
|   512 |           337,276 |           170,688 |      164.68 |       83.34 |
|  1024 |           329,400 |           164,427 |      321.67 |      160.57 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,160 |           168,559 |        5.14 |        2.57 |
|    64 |           338,040 |           174,581 |       20.63 |       10.65 |
|   256 |           331,402 |           164,303 |       80.90 |       40.11 |
|   512 |           345,022 |           175,785 |      168.46 |       85.83 |
|  1024 |           282,690 |           140,914 |      276.06 |      137.61 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           333,652 |           166,806 |        5.09 |        2.54 |
|    64 |           332,134 |           166,006 |       20.27 |       10.13 |
|   256 |           321,696 |           160,353 |       78.53 |       39.14 |
|   512 |           316,536 |           158,273 |      154.55 |       77.28 |
|  1024 |           320,628 |           160,468 |      313.11 |      156.70 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           323,854 |           161,916 |        4.94 |        2.47 |
|    64 |           328,412 |           164,236 |       20.04 |       10.02 |
|   256 |           323,556 |           161,798 |       78.99 |       39.50 |
|   512 |           324,844 |           162,470 |      158.61 |       79.33 |
|  1024 |           318,106 |           159,186 |      310.65 |      155.45 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           240,008 |           120,017 |        3.66 |        1.83 |
|    64 |           266,064 |           133,034 |       16.23 |        8.11 |
|   256 |           265,310 |           132,700 |       64.77 |       32.39 |
|   512 |           266,166 |           133,106 |      129.96 |       64.99 |
|  1024 |           244,680 |           122,354 |      238.94 |      119.48 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,798 |           174,398 |        5.32 |        2.66 |
|    64 |           335,076 |           167,626 |       20.45 |       10.23 |
|   256 |           334,139 |           166,919 |       81.57 |       40.75 |
|   512 |           318,166 |           159,296 |      155.35 |       77.78 |
|  1024 |           329,760 |           165,261 |      322.03 |      161.38 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           262,726 |           131,340 |        4.00 |        2.00 |
|    64 |           248,574 |           124,257 |       15.17 |        7.58 |
|   256 |           254,556 |           127,308 |       62.14 |       31.08 |
|   512 |           254,162 |           126,940 |      124.10 |       61.98 |
|  1024 |           188,658 |            94,213 |      184.23 |       92.00 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           335,094 |           167,708 |        5.11 |        2.55 |
|    64 |           330,390 |           165,207 |       20.16 |       10.08 |
|   256 |           309,606 |           155,097 |       75.58 |       37.86 |
|   512 |           321,512 |           160,804 |      156.98 |       78.51 |
|  1024 |           317,682 |           158,846 |      310.23 |      155.12 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           222,974 |           111,426 |        3.40 |        1.70 |
|    64 |           261,346 |           130,755 |       15.95 |        7.98 |
|   256 |           235,982 |           118,707 |       57.61 |       28.98 |
|   512 |           263,880 |           132,735 |      128.84 |       64.81 |
|  1024 |           210,924 |           105,465 |      205.98 |      102.99 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           249,708 |           124,831 |        3.81 |        1.90 |
|    64 |           224,826 |           113,102 |       13.72 |        6.90 |
|   256 |           250,166 |           125,128 |       61.07 |       30.54 |
|   512 |           255,852 |           128,031 |      124.92 |       62.51 |
|  1024 |           263,026 |           131,498 |      256.86 |      128.41 |
