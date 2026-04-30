# LavinMQ P99 Latency Results

***Important***: These results are from 20s test runs per instance type. Anomalies may be due to transient network conditions, CPU throttling/bursting, background system processes, or queue state variations.

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Rate limit**: Rate limit in msgs/s
- **Message Sizes**: 16, 64 bytes

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.7.0-rc.3.

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### Burstable General-Purpose

**t4g.micro** - 2 vCPU, 1 GiB RAM (ARM-based AWS Graviton2)

| Rate Limit | 16 bytes | 64 bytes |
|-----------:| ---------: | ---------: |
|         10 |      0.43 |      0.44 |
|        100 |      0.77 |      0.60 |
|      1,000 |      1.94 |      2.31 |
|      5,000 |     11.10 |     26.40 |
|     10,000 |     15.96 |     16.59 |
|     50,000 |     38.28 |     19.83 |
|    100,000 |     46.77 |     27.53 |
|    250,000 |     40.95 |     21.17 |
|    500,000 |     37.27 |     29.59 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes |
|-----------:| ---------: | ---------: |
|         10 |      0.30 |      0.23 |
|        100 |      0.49 |      0.55 |
|      1,000 |      1.11 |      1.11 |
|      5,000 |      3.75 |      4.19 |
|     10,000 |      6.46 |      6.65 |
|     50,000 |     31.01 |     29.60 |
|    100,000 |     61.79 |     31.52 |
|    250,000 |    117.75 |     28.46 |
|    500,000 |     97.98 |     35.72 |
