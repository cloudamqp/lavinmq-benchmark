# LavinMQ Throughput Results

## Benchmark Setup

- Network (VPC, internet gateway, subnet, route table, route table associated, ingress rule)
- Benchmark-broker (AWS instance, public IP)
- Benchmark-loadgen (AWS instance, public IP)

Load generator -> AMQP-URL (broker private IP) -> Broker

## Table Headers

- **Size**: Message size in bytes
- **Avg. Publish Rate**: Average publish rate in msgs/s
- **Avg. Consume Rate**: Average consume rate in msgs/s
- **Publish BW**: Publish bandwidth in MiB/s
- **Consume BW**: Consume bandwidth in MiB/s

## AWS Instance Types

Benchmark results for AWS instance types with LavinMQ version v2.8.0-beta.1.

```shell
lavinmqperf throughput -z 60 -x 1 -y 1 -s <size>
```

### CPU Optimized

**c8g.large** - 2 vCPU, 4 GiB RAM (ARM-based AWS Graviton4)

|  Size | Avg. Publish Rate | Avg. Consume Rate |  Publish BW |  Consume BW |
|------:|------------------:|------------------:|------------:|------------:|
|    16 |           934,323 |           934,163 |       14.25 |       14.25 |
|    64 |           881,362 |           881,183 |       53.79 |       53.78 |
|   256 |           731,849 |           731,798 |      178.67 |      178.66 |
|   512 |           588,010 |           587,966 |      287.11 |      287.09 |
|  1024 |           432,566 |           430,153 |      422.42 |      420.07 |
|  4096 |           112,570 |           112,244 |      439.72 |      438.45 |
| 16384 |            28,527 |            28,481 |      445.73 |      445.01 |
| 65536 |             7,125 |             7,121 |      445.31 |      445.06 |
