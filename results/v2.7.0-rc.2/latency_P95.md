# LavinMQ P95 Latency Results

Results are the **median of 3 runs** per instance type. Using the median reduces the impact of transient anomalies (CPU bursting, network jitter, queue state variations) that can skew single-run results.

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Rate limit**: Rate limit in msgs/s
- **Message Sizes**: 16, 64, 256, 512, 1024, 4096, 16384, 65536 bytes

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.7.0-rc.2.

Command:

```shell
lavinmqperf throughput -z 20 -x 1 -y 1 -s <size> -r <rate-limit> --measure-latency
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

| Rate Limit | 16 bytes | 64 bytes | 256 bytes | 512 bytes | 1024 bytes | 4096 bytes | 16384 bytes | 65536 bytes |
|-----------:|---------:|---------:|----------:|----------:|-----------:|-----------:|------------:|------------:|
|         10 |     0.52 |     0.34 |      0.41 |      0.40 |       0.46 |       0.68 |        1.05 |        2.28 |
|        100 |     0.76 |     0.74 |      0.78 |      0.91 |       0.99 |       1.67 |        3.20 |        7.81 |
|      1,000 |     1.73 |     1.66 |      1.80 |      2.50 |       2.80 |       7.10 |       11.37 |       10.71 |
|     10,000 |    10.79 |    10.90 |     12.24 |      9.56 |       8.94 |      13.52 |       16.86 |       13.19 |
|     50,000 |    51.56 |    51.98 |     63.95 |      8.98 |      12.94 |      13.03 |       14.83 |       13.65 |
|    100,000 |   101.69 |   107.76 |      9.97 |     10.06 |      12.09 |      14.75 |       13.11 |       41.44 |
|    200,000 |   202.08 |   210.58 |     11.59 |     13.95 |      29.88 |      18.48 |       10.68 |       15.17 |
|    500,000 |   521.33 |   463.22 |     29.71 |     30.55 |     315.63 |      15.13 |       13.04 |       14.59 |
