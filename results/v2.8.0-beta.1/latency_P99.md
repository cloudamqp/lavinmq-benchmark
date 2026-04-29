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

Benchmark results for AWS instance types with LavinMQ version v2.8.0-beta.1.

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes | 256 bytes | 512 bytes | 1024 bytes | 4096 bytes | 16384 bytes | 65536 bytes |
|-----------:| ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: | ---------: |
|         10 |      0.22 |      0.33 |      0.35 |      0.45 |      0.42 |      0.44 |      1.49 |      1.91 |
|        100 |      0.38 |      0.54 |      0.31 |      0.54 |      0.85 |      1.51 |      2.62 |      2.95 |
|      1,000 |      1.15 |      1.13 |      1.46 |      2.44 |      2.34 |      3.09 |      3.06 |      3.46 |
|      5,000 |      3.68 |      4.11 |      4.15 |      5.14 |      4.29 |      5.38 |      3.92 |         - |
|     10,000 |      6.45 |      6.75 |      7.73 |      6.64 |      4.17 |      4.24 |         - |         - |
|     50,000 |     31.39 |     31.52 |     15.31 |      6.13 |      5.53 |         - |         - |         - |
|    100,000 |     62.62 |     36.38 |      8.80 |      7.68 |         - |         - |         - |         - |
|    250,000 |     91.16 |     51.29 |     15.48 |         - |         - |         - |         - |         - |
|    500,000 |     98.59 |     93.65 |         - |         - |         - |         - |         - |         - |
