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

Benchmark results for AWS instance types with LavinMQ version v2.7.0-rc.1.

Command:

```shell
lavinmqperf throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           537,778 |           537,612 |        8.20 |        8.20 |
|    64 |           530,975 |           530,866 |       32.40 |       32.40 |
|   256 |           397,785 |           397,733 |       97.11 |       97.10 |
|   512 |           311,919 |           311,880 |      152.30 |      152.28 |
|  1024 |           212,186 |           212,167 |      207.21 |      207.19 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           563,778 |           563,629 |        8.60 |        8.60 |
|    64 |           534,667 |           534,554 |       32.63 |       32.62 |
|   256 |           404,368 |           404,316 |       98.72 |       98.70 |
|   512 |           271,240 |           271,193 |      132.44 |      132.41 |
|  1024 |           174,233 |           174,208 |      170.14 |      170.12 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           565,900 |           565,727 |        8.63 |        8.63 |
|    64 |           516,107 |           515,947 |       31.50 |       31.49 |
|   256 |           394,468 |           394,422 |       96.30 |       96.29 |
|   512 |           294,653 |           294,619 |      143.87 |      143.85 |
|  1024 |           199,357 |           199,324 |      194.68 |      194.65 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           812,294 |           812,092 |       12.39 |       12.39 |
|    64 |           754,716 |           754,577 |       46.06 |       46.05 |
|   256 |           591,595 |           591,542 |      144.43 |      144.41 |
|   512 |           454,631 |           454,601 |      221.98 |      221.97 |
|  1024 |           309,656 |           309,617 |      302.39 |      302.36 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           828,836 |           828,678 |       12.64 |       12.64 |
|    64 |           772,277 |           772,162 |       47.13 |       47.12 |
|   256 |           641,313 |           641,261 |      156.57 |      156.55 |
|   512 |           492,037 |           492,012 |      240.25 |      240.24 |
|  1024 |           333,771 |           333,751 |      325.94 |      325.92 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           845,488 |           845,350 |       12.90 |       12.89 |
|    64 |           795,936 |           795,808 |       48.58 |       48.57 |
|   256 |           645,991 |           645,936 |      157.71 |      157.69 |
|   512 |           504,623 |           504,593 |      246.39 |      246.38 |
|  1024 |           370,190 |           370,167 |      361.51 |      361.49 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           994,301 |           993,935 |       15.17 |       15.16 |
|    64 |           919,750 |           919,641 |       56.13 |       56.13 |
|   256 |           758,653 |           758,567 |      185.21 |      185.19 |
|   512 |           611,270 |           611,221 |      298.47 |      298.44 |
|  1024 |           412,536 |           412,497 |      402.86 |      402.82 |

### Storage Optimized

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           686,145 |           686,140 |       10.46 |       10.46 |
|    64 |           678,254 |           678,247 |       41.39 |       41.39 |
|   256 |           565,999 |           565,414 |      138.18 |      138.04 |
|   512 |           500,132 |           414,098 |      244.20 |      202.19 |
|  1024 |           357,113 |           356,914 |      348.74 |      348.54 |

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           998,008 |           997,853 |       15.22 |       15.22 |
|    64 |           926,245 |           926,130 |       56.53 |       56.52 |
|   256 |           783,402 |           783,341 |      191.26 |      191.24 |
|   512 |           629,451 |           629,383 |      307.34 |      307.31 |
|  1024 |           433,451 |           433,419 |      423.29 |      423.26 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |         1,033,173 |             4,324 |       15.76 |         .06 |
|    64 |           682,960 |           682,878 |       41.68 |       41.67 |
|   256 |           246,253 |           246,177 |       60.12 |       60.10 |
|   512 |           128,073 |           128,024 |       62.53 |       62.51 |
|  1024 |            65,763 |            65,741 |       64.22 |       64.20 |
