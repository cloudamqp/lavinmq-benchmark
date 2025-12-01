# LavinMQ Throughput results

## Benchmark setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## AWS instance types

Benchmark result for AWS instance types with  LavinMQ version v2.4.0.

Command:

```shell
lavinmqperf throughput -z 120 -x 1 -y 1 -s 16
```

### Burstable general-purpose

- t4g: Uses ARM based AWS Graviton2 processors and are a cost-effective, burstable general-purpose
       instance type.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| t4g.micro        |  382,922 msgs/s   |  382,447 msgs/s   | 2 vCPU, 1 GiB RAM     |
| t4g.small        |  384,293 msgs/s   |  383,988 msgs/s   | 2 vCPU, 2 GiB RAM     |
| t4g.medium       |  387,017 msgs/s   |  386,831 msgs/s   | 2 vCPU, 4 GiB RAM     |

### Memory optimized

- r7g: Uses ARM based AWS Graviton3 process are optimized for memory intensive workloads.
- x2iezn: Uses AMD based 2nd generation Intel Xeon Scalable ideal for memory intense workloads.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| r7g.large        | 538,016 msgs/s    | 537,909 msgs/s    | 2 vCPU, 16 GiB RAM    |
| r7g.xlarge       | 543,810 msgs/s    | 543,706 msgs/s    | 4 vCPU, 32 GiB RAM    |

### CPU optimized

- c8g: Uses ARM based AWS Graviton4 and are ideal for compute-intensive workloads, such as high
       performance computing.
- c7a: Uses AMD based 4th generation AMD EPYC processors are ideal for high performance,
       compute-intensive workloads.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| c8g.large        | 672,600 msgs/s    | 672,284 msgs/s    | 2 vCPU, 4 GiB RAM     |
| c7a.large        | 445,505 msgs/s    | 445,352 msgs/s    | 2 vCPU, 4 GiB RAM     |

### Storage optimized

- i7i, i7ie: Uses AMD based 5th generation Intel Xeon Scalable and are optimized for storage-intensive
             workloads that require high-speed access to data residing on local NVMe storage.
- i8g: Uses ARM based AWS Graviton4 and are optimized for storage-intensive workloads that require
       high-speed access to data residing on local NVMe storage.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| i7i.large        | 874,380 msgs/s    | 874,187 msgs/s    | 2 vCPU, 16 GiB RAM    |
| i8g.large        | 684,902 msgs/s    | 684,448 msgs/s    | 2 vCPU, 16 GiB RAM    |

### High single-threaded and memory performance

- zid: Uses AMD based custom Intel® Xeon® Scalable processor ideal for applications requiring high
       single threaded performance and high memory usage

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| z1d.large        | 515,776 msgs/s    | 515,655 msgs/s    | 2 vCPU, 16 GiB RAM    |
