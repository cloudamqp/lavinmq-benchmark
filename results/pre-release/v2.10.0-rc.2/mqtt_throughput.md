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

Benchmark results for AWS instance types with LavinMQ version v2.10.0-rc.2.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           332,491 |           165,637 |        5.07 |        2.52 |
|    64 |           324,652 |           162,353 |       19.81 |        9.90 |
|   256 |           342,252 |           175,202 |       83.55 |       42.77 |
|   512 |           333,462 |           166,715 |      162.82 |       81.40 |
|  1024 |           309,844 |           153,980 |      302.58 |      150.37 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           326,296 |           163,197 |        4.97 |        2.49 |
|    64 |           329,581 |           164,788 |       20.11 |       10.05 |
|   256 |           339,866 |           176,859 |       82.97 |       43.17 |
|   512 |           333,786 |           168,529 |      162.98 |       82.28 |
|  1024 |           300,442 |           149,998 |      293.40 |      146.48 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           356,412 |           180,402 |        5.43 |        2.75 |
|    64 |           336,694 |           168,337 |       20.55 |       10.27 |
|   256 |           343,208 |           170,947 |       83.79 |       41.73 |
|   512 |           338,072 |           172,762 |      165.07 |       84.35 |
|  1024 |           303,854 |           150,308 |      296.73 |      146.78 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           340,864 |           170,406 |        5.20 |        2.60 |
|    64 |           338,420 |           168,747 |       20.65 |       10.29 |
|   256 |           328,172 |           164,079 |       80.12 |       40.05 |
|   512 |           340,864 |           170,412 |      166.43 |       83.20 |
|  1024 |           327,726 |           164,488 |      320.04 |      160.63 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           357,414 |           178,738 |        5.45 |        2.72 |
|    64 |           340,278 |           170,133 |       20.76 |       10.38 |
|   256 |           322,838 |           161,522 |       78.81 |       39.43 |
|   512 |           335,296 |           168,008 |      163.71 |       82.03 |
|  1024 |           327,204 |           163,568 |      319.53 |      159.73 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           337,036 |           168,472 |        5.14 |        2.57 |
|    64 |           325,554 |           162,638 |       19.87 |        9.92 |
|   256 |           311,008 |           155,620 |       75.92 |       37.99 |
|   512 |           325,346 |           158,536 |      158.86 |       77.41 |
|  1024 |           326,660 |           163,257 |      319.00 |      159.43 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           336,506 |           168,255 |        5.13 |        2.56 |
|    64 |           340,726 |           169,805 |       20.79 |       10.36 |
|   256 |           315,606 |           157,806 |       77.05 |       38.52 |
|   512 |           317,708 |           158,741 |      155.13 |       77.51 |
|  1024 |           324,772 |           162,316 |      317.16 |      158.51 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           270,894 |           135,488 |        4.13 |        2.06 |
|    64 |           279,810 |           138,697 |       17.07 |        8.46 |
|   256 |           252,130 |           126,036 |       61.55 |       30.77 |
|   512 |           233,782 |           117,282 |      114.15 |       57.26 |
|  1024 |           254,758 |           126,805 |      248.78 |      123.83 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,836 |           169,851 |        5.18 |        2.59 |
|    64 |           320,192 |           160,084 |       19.54 |        9.77 |
|   256 |           346,746 |           173,358 |       84.65 |       42.32 |
|   512 |           333,580 |           166,357 |      162.88 |       81.22 |
|  1024 |           322,620 |           161,322 |      315.05 |      157.54 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           248,041 |           123,974 |        3.78 |        1.89 |
|    64 |           268,426 |           134,564 |       16.38 |        8.21 |
|   256 |           209,656 |           106,100 |       51.18 |       25.90 |
|   512 |           259,588 |           129,758 |      126.75 |       63.35 |
|  1024 |           286,502 |           143,510 |      279.78 |      140.14 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           266,512 |           133,273 |        4.06 |        2.03 |
|    64 |           265,012 |           132,624 |       16.17 |        8.09 |
|   256 |           255,006 |           127,568 |       62.25 |       31.14 |
|   512 |           264,258 |           132,379 |      129.03 |       64.63 |
|  1024 |           264,934 |           132,380 |      258.72 |      129.27 |
