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

Benchmark results for AWS instance types with LavinMQ version v2.8.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           341,238 |           170,618 |        5.20 |        2.60 |
|    64 |           338,327 |           167,929 |       20.64 |       10.24 |
|   256 |           331,994 |           167,387 |       81.05 |       40.86 |
|   512 |           350,064 |           175,617 |      170.92 |       85.75 |
|  1024 |           281,410 |           140,816 |      274.81 |      137.51 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           323,132 |           161,590 |        4.93 |        2.46 |
|    64 |           333,956 |           166,847 |       20.38 |       10.18 |
|   256 |           335,855 |           168,126 |       81.99 |       41.04 |
|   512 |           346,676 |           174,269 |      169.27 |       85.09 |
|  1024 |           281,922 |           142,220 |      275.31 |      138.88 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           354,770 |           179,804 |        5.41 |        2.74 |
|    64 |           347,104 |           174,199 |       21.18 |       10.63 |
|   256 |           352,774 |           181,025 |       86.12 |       44.19 |
|   512 |           294,244 |           146,729 |      143.67 |       71.64 |
|  1024 |           240,544 |           120,078 |      234.90 |      117.26 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           347,372 |           174,498 |        5.30 |        2.66 |
|    64 |           326,264 |           162,638 |       19.91 |        9.92 |
|   256 |           318,102 |           158,915 |       77.66 |       38.79 |
|   512 |           324,940 |           162,435 |      158.66 |       79.31 |
|  1024 |           333,598 |           166,886 |      325.77 |      162.97 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           348,322 |           174,154 |        5.31 |        2.65 |
|    64 |           330,810 |           165,412 |       20.19 |       10.09 |
|   256 |           332,096 |           166,016 |       81.07 |       40.53 |
|   512 |           335,452 |           167,707 |      163.79 |       81.88 |
|  1024 |           329,370 |           164,806 |      321.65 |      160.94 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           339,148 |           169,580 |        5.17 |        2.58 |
|    64 |           347,514 |           173,061 |       21.21 |       10.56 |
|   256 |           326,046 |           163,274 |       79.60 |       39.86 |
|   512 |           325,750 |           162,915 |      159.05 |       79.54 |
|  1024 |           321,720 |           160,860 |      314.17 |      157.08 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           334,143 |           166,974 |        5.09 |        2.54 |
|    64 |           330,244 |           165,325 |       20.15 |       10.09 |
|   256 |           327,970 |           163,911 |       80.07 |       40.01 |
|   512 |           331,434 |           165,582 |      161.83 |       80.85 |
|  1024 |           327,702 |           163,545 |      320.02 |      159.71 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           189,027 |            94,108 |        2.88 |        1.43 |
|    64 |           208,006 |           104,267 |       12.69 |        6.36 |
|   256 |           264,570 |           132,525 |       64.59 |       32.35 |
|   512 |           220,266 |           110,117 |      107.55 |       53.76 |
|  1024 |           259,090 |           128,924 |      253.01 |      125.90 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           329,748 |           164,513 |        5.03 |        2.51 |
|    64 |           339,904 |           169,939 |       20.74 |       10.37 |
|   256 |           333,334 |           166,645 |       81.38 |       40.68 |
|   512 |           331,120 |           165,759 |      161.67 |       80.93 |
|  1024 |           338,984 |           169,527 |      331.03 |      165.55 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           216,769 |           107,097 |        3.30 |        1.63 |
|    64 |           218,636 |           109,247 |       13.34 |        6.66 |
|   256 |           213,870 |           106,999 |       52.21 |       26.12 |
|   512 |           259,304 |           129,740 |      126.61 |       63.34 |
|  1024 |           250,961 |           126,150 |      245.07 |      123.19 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           271,614 |           135,795 |        4.14 |        2.07 |
|    64 |           267,088 |           133,469 |       16.30 |        8.14 |
|   256 |           259,171 |           129,219 |       63.27 |       31.54 |
|   512 |           247,984 |           124,080 |      121.08 |       60.58 |
|  1024 |           227,228 |           113,712 |      221.90 |      111.04 |
