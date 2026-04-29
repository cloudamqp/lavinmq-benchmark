# LavinMQ P95 Latency Results

***Important***: These results are from 20s test runs per instance type. Anomalies may be due to transient network conditions, CPU throttling/bursting, background system processes, or queue state variations.

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Rate limit**: Rate limit in msgs/s
- **Message Sizes**: 16, 64, 256, 512, 1024, 4096, 16384, 65536 bytes

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.8.0-beta.1.

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes | 256 bytes | 512 bytes | 1024 bytes | 4096 bytes | 16384 bytes | 65536 bytes |
|-----------:| ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: |
|         10 |      0.19 |      0.31 |      0.34 |      0.32 |      0.37 |      0.43 |      0.70 |      1.30 |
|        100 |      0.31 |      0.36 |      0.30 |      0.46 |      0.66 |      1.08 |      2.18 |      2.67 |
|      1,000 |      1.06 |      1.08 |      1.17 |      1.68 |      2.17 |      2.79 |      2.72 |      3.09 |
|      5,000 |      3.24 |      3.39 |      3.95 |      4.93 |      3.75 |      3.97 |      3.51 |         - |
|     10,000 |      6.36 |      6.56 |      7.63 |      5.28 |      3.71 |      2.73 |         - |         - |
|     50,000 |     31.13 |     28.03 |      8.35 |      4.98 |      4.67 |         - |         - |         - |
|    100,000 |     61.00 |     21.81 |      6.74 |      5.57 |         - |         - |         - |         - |
|    250,000 |     79.78 |     20.86 |      9.86 |         - |         - |         - |         - |         - |
|    500,000 |     81.13 |     72.81 |         - |         - |         - |         - |         - |         - |
