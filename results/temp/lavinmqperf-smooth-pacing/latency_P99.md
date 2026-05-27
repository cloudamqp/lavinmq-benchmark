# LavinMQ P99 Latency Results

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

Benchmark results for AWS instance types with LavinMQ version vlavinmqperf-smooth-pacing.

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes | 256 bytes | 512 bytes | 1024 bytes | 4096 bytes | 16384 bytes | 65536 bytes |
|-----------:| ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: |
|         10 |      0.11 |      0.13 |      0.12 |      0.29 |      0.16 |      0.32 |      0.34 |      0.54 |
|        100 |      0.15 |      0.09 |      0.09 |      0.10 |      0.11 |      0.18 |      0.40 |      0.55 |
|      1,000 |      0.33 |      0.20 |      0.33 |      0.34 |      0.33 |      0.35 |      0.60 |      1.04 |
|      5,000 |      0.33 |      0.28 |      0.41 |      0.28 |      0.37 |      0.46 |      1.07 |         - |
|     10,000 |      0.33 |      0.35 |      0.34 |      0.34 |      0.43 |      0.59 |         - |         - |
|     50,000 |      0.48 |      0.40 |      0.51 |      0.58 |      0.82 |         - |         - |         - |
|    100,000 |      0.57 |      0.68 |      1.06 |      1.32 |         - |         - |         - |         - |
|    250,000 |      5.06 |      4.98 |      5.55 |         - |         - |         - |         - |         - |
|    500,000 |     21.01 |     21.61 |         - |         - |         - |         - |         - |         - |
