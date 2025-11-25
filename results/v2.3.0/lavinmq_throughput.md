# LavinMQ Throughput results

## Benchmark setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## AWS instance types

Benchmark result for AWS instance types with  LavinMQ version v2.3.0.

Command:

```shell
lavinmqperf throughput -z 120 -x 1 -y 1 -s 16
```

### Burstable general-purpose

- t4g: Uses ARM based AWS Graviton2 processors and are a cost-effective, burstable general-purpose
       instance type.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| t4g.micro        | 363,440 msgs/s    | 361,397 msgs/s    | 2 vCPU, 1 GiB RAM     |
| t4g.small        | 407,858 msgs/s    | 406,949 msgs/s    | 2 vCPU, 2 GiB RAM     |
| t4g.medium       | 410,406 msgs/s    | 409,576 msgs/s    | 2 vCPU, 4 GiB RAM     |

### Memory optimized

- r7g: Uses ARM based AWS Graviton3 process are optimized for memory intensive workloads.
- x2iezn: Uses AMD based 2nd generation Intel Xeon Scalable ideal for memory intense workloads.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| r7g.medium       | 570,294 msgs/s    | 570,088 msgs/s    | 1 vCPU, 8 GiB RAM     |
| r7g.large        | 570,541 msgs/s    | 570,367 msgs/s    | 2 vCPU, 16 GiB RAM    |
| r7g.xlarge       | 577,648 msgs/s    | 577,556 msgs/s    | 4 vCPU, 32 GiB RAM    |
| r7g.2xlarge      | 573,723 msgs/s    | 573,467 msgs/s    | 8 vCPU, 64 GiB RAM    |
| x2iezn.2xlarge   | 593,247 msgs/s    | 592,909 msgs/s    | 8 vCPU, 256 GiB RAM   |

### CPU optimized

- c8g: Uses ARM based AWS Graviton4 and are ideal for compute-intensive workloads, such as high
       performance computing.
- c7a: Uses AMD based 4th generation AMD EPYC processors are ideal for high performance,
       compute-intensive workloads.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| c8g.large        | 788,907 msgs/s    | 788,540 msgs/s    | 2 vCPU, 4 GiB RAM     |
| c7a.large        | 511,524 msgs/s    | 511,183 msgs/s    | 2 vCPU, 4 GiB RAM     |

### Storage optimized

- i7i, i7ie: Uses AMD based 5th generation Intel Xeon Scalable and are optimized for storage-intensive
             workloads that require high-speed access to data residing on local NVMe storage.
- i8g: Uses ARM based AWS Graviton4 and are optimized for storage-intensive workloads that require
       high-speed access to data residing on local NVMe storage.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| i7i.large        | 917,403 msgs/s    | 917,173 msgs/s    | 2 vCPU, 16 GiB RAM    |
| i7ie.large       | 897,870 msgs/s    | 897,550 msgs/s    | 2 vCPU, 16 GiB RAM    |
| i8g.large        | 795,584 msgs/s    | 795,198 msgs/s    | 2 vCPU, 16 GiB RAM    |

### Memory bound and data intensive

- hpc6id: Uses AMD based 3rd Generation Intel Xeon Scalable processors, offer cost-effective price
          performance for memory-bound and data-intensive high performance computing workloads.

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| hpc6id.32xlarge  | 672,819 msgs/s    | 672,314 msgs/s    | 32 vCPU, 1024 GiB RAM |

### High single-threaded and memory performance

- zid: Uses AMD based custom Intel® Xeon® Scalable processor ideal for applications requiring high
       single threaded performance and high memory usage

| Instance type    | Avg. Publish rate | Avg. Consume rate | Comment               |
| ---------------- | ----------------- | ----------------- | --------------------- |
| z1d.large        | 536,873 msgs/s    | 536,596 msgs/s    | 2 vCPU, 16 GiB RAM    |
