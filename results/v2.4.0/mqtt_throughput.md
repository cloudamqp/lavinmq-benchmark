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

Benchmark results for AWS instance types with LavinMQ version v2.4.0.

```shell
mqtt_bench.sh throughput -z 60 -x 1 -y 1 -s <size>
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**t4g.small** - 2 vCPU, 2 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**t4g.medium** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton2)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

### Memory Optimized

**r7g.medium** - 1 vCPU, 8 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**r7g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**r7g.xlarge** - 4 vCPU, 32 GiB RAM (ARM-based AWS Graviton3)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**c7a.large** - 2 vCPU, 4 GiB RAM (AMD-based 4th gen EPYC)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

### Storage Optimized

**i8g.large** - 2 vCPU, 16 GiB RAM (ARM-based AWS Graviton4, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

**i7i.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon 5th gen, local NVMe)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |

### High Single-Threaded Performance

**z1d.large** - 2 vCPU, 16 GiB RAM (AMD-based Intel Xeon Scalable)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |                 0 |                 0 |        0.00 |        0.00 |
|    64 |                 0 |                 0 |        0.00 |        0.00 |
|   256 |                 0 |                 0 |        0.00 |        0.00 |
|   512 |                 0 |                 0 |        0.00 |        0.00 |
|  1024 |                 0 |                 0 |        0.00 |        0.00 |
