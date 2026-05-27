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

Benchmark results for AWS instance types with LavinMQ version vlavinmqperf-smooth-pacing.

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes | 256 bytes | 512 bytes | 1024 bytes | 4096 bytes | 16384 bytes | 65536 bytes |
|-----------:| ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: |
|         10 |      0.10 |      0.10 |      0.10 |      0.29 |      0.15 |      0.29 |      0.27 |      0.40 |
|        100 |      0.15 |      0.08 |      0.08 |      0.09 |      0.09 |      0.11 |      0.25 |      0.43 |
|      1,000 |      0.32 |      0.20 |      0.32 |      0.34 |      0.32 |      0.35 |      0.47 |      0.68 |
|      5,000 |      0.32 |      0.27 |      0.38 |      0.28 |      0.34 |      0.42 |      0.81 |         - |
|     10,000 |      0.32 |      0.33 |      0.32 |      0.31 |      0.41 |      0.45 |         - |         - |
|     50,000 |      0.43 |      0.27 |      0.39 |      0.48 |      0.59 |         - |         - |         - |
|    100,000 |      0.51 |      0.51 |      0.68 |      0.78 |         - |         - |         - |         - |
|    250,000 |      0.80 |      0.77 |      0.86 |         - |         - |         - |         - |         - |
|    500,000 |      1.61 |      1.86 |         - |         - |         - |         - |         - |         - |
