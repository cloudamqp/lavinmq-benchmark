# LavinMQ Throughput Results

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Size**: Message size in bytes
- **Avg. Publish Rate**: Average publish rate in msgs/s
- **Avg. Consume Rate**: Average consume rate in msgs/s
- **Publish BW**: Publish bandwidth in MiB/s
- **Consume BW**: Consume bandwidth in MiB/s

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.6.0.

Command:

```shell
lavinmqperf throughput -z 120 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           578,788 |           578,598 |        8.83 |        8.82 |
|    64 |           558,734 |           558,478 |       34.10 |       34.08 |
|   256 |           434,480 |           434,386 |      106.07 |      106.05 |
|   512 |           282,271 |           282,235 |      137.82 |      137.81 |
|  1024 |           215,089 |           215,064 |      210.04 |      210.02 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           581,390 |           581,226 |        8.87 |        8.86 |
|    64 |           513,605 |           513,503 |       31.34 |       31.34 |
|   256 |           439,969 |           439,915 |      107.41 |      107.40 |
|   512 |           251,898 |           251,865 |      122.99 |      122.98 |
|  1024 |           219,607 |           219,582 |      214.45 |      214.43 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           612,286 |           612,083 |        9.34 |        9.33 |
|    64 |           601,799 |           601,641 |       36.73 |       36.72 |
|   256 |           458,494 |           458,425 |      111.93 |      111.92 |
|   512 |           341,967 |           341,911 |      166.97 |      166.94 |
|  1024 |           276,557 |           276,523 |      270.07 |      270.04 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           860,652 |           860,411 |       13.13 |       13.12 |
|    64 |           798,311 |           798,198 |       48.72 |       48.71 |
|   256 |           623,933 |           623,879 |      152.32 |      152.31 |
|   512 |           482,167 |           482,122 |      235.43 |      235.41 |
|  1024 |           327,115 |           327,095 |      319.44 |      319.42 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           881,440 |           881,244 |       13.44 |       13.44 |
|    64 |           820,103 |           819,984 |       50.05 |       50.04 |
|   256 |           658,236 |           658,164 |      160.70 |      160.68 |
|   512 |           534,848 |           534,801 |      261.15 |      261.13 |
|  1024 |           366,887 |           366,866 |      358.28 |      358.26 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           889,643 |           889,450 |       13.57 |       13.57 |
|    64 |           836,483 |           836,297 |       51.05 |       51.04 |
|   256 |           680,738 |           680,694 |      166.19 |      166.18 |
|   512 |           539,505 |           539,444 |      263.43 |      263.40 |
|  1024 |           371,946 |           371,914 |      363.22 |      363.19 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |         1,007,903 |         1,007,687 |       15.37 |       15.37 |
|    64 |           980,458 |           980,321 |       59.84 |       59.83 |
|   256 |           783,254 |           783,127 |      191.22 |      191.19 |
|   512 |           622,658 |           622,603 |      304.03 |      304.00 |
|  1024 |           449,581 |           449,550 |      439.04 |      439.01 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           727,395 |           727,391 |       11.09 |       11.09 |
|    64 |           660,372 |           660,368 |       40.30 |       40.30 |
|   256 |           564,396 |           564,382 |      137.79 |      137.78 |
|   512 |           401,691 |           401,689 |      196.13 |      196.13 |
|  1024 |           373,492 |           373,474 |      364.73 |      364.72 |

### Storage Optimized

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           760,731 |           760,645 |       11.60 |       11.60 |
|    64 |           658,557 |           658,553 |       40.19 |       40.19 |
|   256 |           507,393 |           507,390 |      123.87 |      123.87 |
|   512 |           435,022 |           435,018 |      212.41 |      212.41 |
|  1024 |           371,843 |           371,820 |      363.12 |      363.10 |

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |         1,031,790 |         1,031,537 |       15.74 |       15.74 |
|    64 |           971,414 |           971,289 |       59.29 |       59.28 |
|   256 |           800,508 |           800,417 |      195.43 |      195.41 |
|   512 |           648,120 |           648,071 |      316.46 |      316.44 |
|  1024 |           449,163 |           449,137 |      438.63 |      438.61 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           705,965 |           705,931 |       10.77 |       10.77 |
|    64 |           624,924 |           624,832 |       44.24 |       44.24 |
|   256 |           478,318 |           478,269 |      116.77 |      116.76 |
|   512 |           442,660 |           439,492 |      216.14 |      214.59 |
|  1024 |           290,173 |           290,149 |      283.37 |      283.34 |
