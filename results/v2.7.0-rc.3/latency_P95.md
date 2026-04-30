# LavinMQ P95 Latency Results

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
|         10 |      0.42 |      0.43 |
|        100 |      0.64 |      0.59 |
|      1,000 |      1.90 |      2.12 |
|      5,000 |      7.72 |     10.22 |
|     10,000 |     13.88 |     15.07 |
|     50,000 |     35.29 |     17.68 |
|    100,000 |     42.49 |     24.18 |
|    250,000 |     37.86 |     17.84 |
|    500,000 |     29.65 |     18.47 |

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes |
|-----------:| ---------: | ---------: |
|         10 |      0.26 |      0.21 |
|        100 |      0.36 |      0.42 |
|      1,000 |      1.06 |      0.97 |
|      5,000 |      3.20 |      3.42 |
|     10,000 |      6.33 |      6.53 |
|     50,000 |     30.82 |     21.00 |
|    100,000 |     60.40 |     27.41 |
|    250,000 |     95.05 |     17.42 |
|    500,000 |     85.02 |     24.90 |
