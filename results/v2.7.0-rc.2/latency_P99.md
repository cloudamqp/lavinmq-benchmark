# LavinMQ P99 Latency Results

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
|         10 |     0.52 |     0.39 |      0.41 |      0.59 |       0.53 |       0.69 |        1.06 |        2.62 |
|        100 |     0.90 |     1.04 |      0.81 |      1.07 |       1.69 |       1.88 |        3.44 |        9.67 |
|      1,000 |     1.87 |     2.35 |      2.06 |      2.94 |       4.03 |       8.37 |       13.64 |       12.64 |
|     10,000 |    11.42 |    11.47 |     13.39 |     11.04 |      21.10 |      16.68 |       20.06 |       18.79 |
|     50,000 |    53.09 |    53.47 |     66.61 |     11.97 |      15.33 |      17.61 |       21.69 |       50.06 |
|    100,000 |   105.12 |   111.38 |     12.43 |    155.85 |      22.62 |      19.66 |       15.30 |       52.03 |
|    200,000 |   206.20 |   217.58 |     15.47 |     18.67 |     134.40 |      20.90 |       13.97 |       20.11 |
|    500,000 |   885.88 |   513.65 |     65.58 |     35.38 |     322.95 |      17.63 |       16.86 |       20.36 |
