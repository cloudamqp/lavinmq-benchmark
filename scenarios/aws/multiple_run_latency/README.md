# Multiple Run Latency Benchmark

This scenario runs multiple sequential latency tests with different message sizes and rate limits against a LavinMQ
broker instance, automatically collecting and summarizing the results in markdown tables.

## What It Does

1. **Provisions AWS Infrastructure**:
   - VPC with subnet and security groups
   - One broker instance with LavinMQ installed and running
   - One load generator instance with LavinMQ tools installed

2. **Runs Sequential Tests**:
   - For each configured message size:
     - For each configured rate limit:
       - Purges the test queue via LavinMQ HTTP API
       - Runs `lavinmqperf throughput` test with `--measure-latency` flag
       - Captures latency percentiles (min, median, p75, p95, p99) and bandwidth

3. **Generates Results**:
   - Creates one markdown table per message size showing latency metrics across rate limits
   - Stores results on the load generator instance at `/home/ubuntu/latency_results.md`
   - Displays results in Terraform output

## Prerequisites

- Terraform >= 1.3.0
- AWS credentials configured
- SSH key pair for instance access
- `dotenv` for loading environment variables (optional but recommended)

## Configuration

### Required Variables

Configure these in your `.env` file or pass via `-var` flags:

```bash
# AWS Credentials
AWS_ACCESS_KEY=***
AWS_SECRET_KEY=***

# AWS region
TF_VAR_aws_region="us-east-1"
TF_VAR_aws_availability_zone="us-east-1a"

# SSH key access, path to your public key and name the key.
TF_VAR_public_ssh_key="~/.ssh/id_ed25519.pub"
TF_VAR_ssh_key_name="lavinmq-benchmark"

# Information set to AWS resources
TF_VAR_tag_created_by="test@benchmark"
TF_VAR_tag_name="lavinmq-benchmark"

# Benchmark servers
# Broker server
TF_VAR_broker_instance_type="c8g.large"
TF_VAR_broker_name="Benchmark-broker"

# Load generator server
TF_VAR_load_generator_count=1
TF_VAR_load_generator_instance_type="c8g.large"
TF_VAR_load_generator_name="Benchmark-loadgen"
```

### Optional Variables (with defaults)

```bash
# Infrastructure
TF_VAR_ami_arch = "arm64"                                                    # or "amd64"
TF_VAR_ubuntu_code_name = "noble"                                            # Ubuntu version

# Benchmark server
TF_VAR_broker_volume_size = 8                                               # Root disk size in GB
TF_VAR_load_generator_volume_size = 8                                       # Root disk size in GB
TF_VAR_lavinmq_version = ""                                                 # Empty = latest, or specify version

# Test configuration
TF_VAR_message_sizes = [16, 64, 256, 512, 1024]                            # Message sizes in bytes
TF_VAR_rate_limits = [10, 100, 1000, 10000, 50000, 100000, 200000, 500000] # Rate limits in msgs/s
TF_VAR_test_duration = 120                                                  # Duration of each test in seconds
```

## Usage

### 1. Initialize Terraform

```bash
cd scenarios/aws/multiple_run_latency
terraform init
```

### 2. Run the Benchmark

Using dotenv (recommended):

```bash
dotenv terraform apply
```

Or with explicit variables:

```bash
terraform apply \
  -var="aws_region=us-east-1" \
  -var="aws_availability_zone=us-east-1a" \
  -var="broker_instance_type=c8g.large" \
  -var="load_generator_instance_type=c8g.large" \
  -var="ssh_key_name=my-keypair" \
  -var="public_ssh_key=~/.ssh/id_rsa.pub"
```

### 3. Customize Test Parameters

Override message sizes:

```bash
dotenv terraform apply -var='message_sizes=[16,64,256,512]'
```

Override rate limits:

```bash
dotenv terraform apply -var='rate_limits=[100,1000,10000,100000]'
```

Override test duration:

```bash
dotenv terraform apply -var="test_duration=60"
```

## Outputs

After successful completion, Terraform provides:

```console
broker_public_dns = "ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
load_generator_public_dns = "ec2-yy-yy-yy-yy.compute-1.amazonaws.com"
results_file_path = "/home/ubuntu/latency_results.md"
ssh_view_results_command = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com 'cat /home/ubuntu/latency_results.md'"
scp_download_results_command = "scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com:/home/ubuntu/latency_results.md ./latency_results.md"
```

## Viewing Results

### View results remotely via SSH

Use the provided command from outputs:

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns> 'cat /home/ubuntu/latency_results.md'
```

### Download results to local machine

```bash
scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>:/home/ubuntu/latency_results.md ./results.md
```

## Example Output

The generated markdown file will look like this (example results):

```markdown
# LavinMQ Latency Test Results

Test Date: 2026-02-23 14:30:00 UTC
Broker Instance Type: c8g.large
LavinMQ Version: 2.5.0

## Message Size: 16 bytes

*Latency (min, median, p75, p95, p99) in milliseconds. Bandwidth (Pub. BW, Con. BW) in MiB/s.*

| Rate Limit | Min | Median | P75 | P95 | P99 | Pub. BW | Con. BW |
|-----------:|----:|-------:|----:|----:|----:|--------:|--------:|
|         10 | 0.123 |  0.234 | 0.345 | 0.456 | 0.567 |    0.00 |    0.00 |
|        100 | 0.234 |  0.345 | 0.456 | 0.567 | 0.678 |    0.00 |    0.00 |
|      1,000 | 0.345 |  0.456 | 0.567 | 0.678 | 0.789 |    0.02 |    0.02 |
|     10,000 | 0.456 |  0.678 | 0.890 | 1.234 | 2.345 |    0.15 |    0.15 |
|     50,000 | 1.234 |  2.345 | 3.456 | 4.567 | 5.678 |    0.76 |    0.76 |
|    100,000 | 2.345 |  3.456 | 4.567 | 5.678 | 6.789 |    1.53 |    1.53 |
|    200,000 | 3.456 |  4.567 | 5.678 | 6.789 | 7.890 |    3.05 |    3.05 |
|    500,000 | 5.678 |  7.890 | 9.012 | 12.345 | 15.678 |    7.63 |    7.63 |

## Message Size: 64 bytes

*Latency (min, median, p75, p95, p99) in milliseconds. Bandwidth (Pub. BW, Con. BW) in MiB/s.*

| Rate Limit | Min | Median | P75 | P95 | P99 | Pub. BW | Con. BW |
|-----------:|----:|-------:|----:|----:|----:|--------:|--------:|
|         10 | 0.145 |  0.256 | 0.367 | 0.478 | 0.589 |    0.00 |    0.00 |
|        100 | 0.256 |  0.367 | 0.478 | 0.589 | 0.690 |    0.01 |    0.01 |
|      1,000 | 0.367 |  0.478 | 0.589 | 0.690 | 0.801 |    0.06 |    0.06 |
|     10,000 | 0.478 |  0.690 | 0.912 | 1.256 | 2.367 |    0.61 |    0.61 |
|     50,000 | 1.256 |  2.367 | 3.478 | 4.589 | 5.690 |    3.05 |    3.05 |
|    100,000 | 2.367 |  3.478 | 4.589 | 5.690 | 6.801 |    6.10 |    6.10 |
|    200,000 | 3.478 |  4.589 | 5.690 | 6.801 | 7.912 |   12.21 |   12.21 |
|    500,000 | 5.690 |  7.912 | 9.134 | 12.367 | 15.690 |   30.52 |   30.52 |

## Test Configuration

- Duration: 120 seconds (`-z 120`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Rate limits: 10,100,1000,10000,50000,100000,200000,500000 msgs/s
- Queue: perf-test
- Latency measurement: Enabled (`--measure-latency`)
```

**Note:** Actual test results are stored at `/home/ubuntu/latency_results.md` on the load generator instance. Use the provided SSH or SCP commands from Terraform outputs to view or download them.

## Understanding Latency Testing

### Rate Limiting

Unlike throughput testing (which measures maximum message rate), latency testing uses **rate limiting** to control message flow and measure end-to-end latency under different load conditions:

- **Low rates** (10-1000 msgs/s): Show baseline latency with minimal contention
- **Medium rates** (10,000-50,000 msgs/s): Show latency under moderate load
- **High rates** (100,000-500,000 msgs/s): Show latency approaching system limits

### Latency Metrics

Each test reports latency in milliseconds:

- **Min**: Fastest message delivery observed
- **Median (p50)**: 50% of messages delivered faster than this
- **P75**: 75th percentile
- **P95**: 95th percentile (SLA indicator)
- **P99**: 99th percentile (tail latency)

Higher percentiles (p95, p99) are crucial for understanding worst-case behavior and setting SLAs.

## Test Details

### What Each Test Does

1. **Queue Purge**: Clears any remaining messages from previous tests via HTTP API

   ```bash
   DELETE http://<broker-ip>:15672/api/queues/%2F/perf-test/contents
   ```

2. **Latency Test**: Runs performance test with rate limiting and latency measurement

   ```bash
   lavinmqperf throughput -z <duration> -x 1 -y 1 -s <size> -r <rate> --measure-latency --uri=amqp://perftest:perftest@<broker-ip>
   ```

   - `-z`: Test duration in seconds
   - `-x 1`: Single producer
   - `-y 1`: Single consumer
   - `-s`: Message size in bytes
   - `-r`: Rate limit in messages per second
   - `--measure-latency`: Enable latency tracking

3. **Result Parsing**: Extracts latency percentiles and throughput from output

### Network Configuration

The scenario creates security group rules allowing:

- **SSH (port 22)**: From anywhere (0.0.0.0/0) for management
- **AMQP (port 5672)**: Within VPC (172.16.0.0/16) for message traffic
- **HTTP API (port 15672)**: Within VPC (172.16.0.0/16) for queue management

## Cleanup

To destroy all resources:

```bash
dotenv terraform destroy
```

Or:

```bash
terraform destroy
```

## Troubleshooting

### Tests fail to connect to broker

- Ensure security groups allow traffic on ports 5672 and 15672 within VPC
- Check broker instance is running: `ssh ubuntu@<broker-dns> 'sudo systemctl status lavinmq'`

### Queue purge fails

- The warning "Queue purge returned HTTP XXX" is normal on first run (queue doesn't exist yet)
- Queue is created automatically when the first test runs

### Results file is empty

- Check the script executed successfully in Terraform output
- SSH to load generator and check: `cat /home/ubuntu/latency_results.md`

### Version fetch fails

- Shows as "Unknown (failed to fetch)" if HTTP API is not accessible
- Tests will still run, only the version display is affected

### High latency at low rates

- Could indicate network issues or broker configuration problems
- Compare with baseline expectations for your instance types

### Rate limit not achieved

- The actual rate may be lower than requested if broker or network is saturated
- Check bandwidth metrics to verify if physical limits are reached

## Script Location

The test orchestration script is located at:
`../../../scripts/run_multiple_latency_tests.sh`

It can be run manually on the load generator for additional tests:

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>
./run_multiple_latency_tests.sh <broker-private-ip> [sizes] [rates] [duration] [broker_instance_type]

# Example:
./run_multiple_latency_tests.sh 172.16.10.5 16,64,256 100,1000,10000 60 c8g.large
```

## Re-running Tests

### Option 1: Taint the Test Resource (Recommended)

Force Terraform to re-run just the test execution without destroying/recreating instances:

```bash
# Mark the test resource for re-execution
terraform taint 'terraform_data.multiple_latency_tests'

# Apply to re-run tests
dotenv terraform apply
```

This will only re-execute the test script without touching the broker or load generator instances.

### Option 2: Use -replace Flag

Directly replace the test resource in one command:

```bash
dotenv terraform apply -replace='terraform_data.multiple_latency_tests'
```

### Option 3: Change Test Parameters

Modify test configuration to trigger automatic re-run:

```bash
# Change message sizes
dotenv terraform apply -var='message_sizes=[16,64,256]'

# Or change rate limits
dotenv terraform apply -var='rate_limits=[100,1000,10000]'

# Or change test duration
dotenv terraform apply -var="test_duration=60"
```

Terraform will detect the change in `triggers_replace` and automatically re-run the tests.

### Option 4: SSH Manually

For quick ad-hoc tests without Terraform:

```bash
# SSH to the load generator
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>

# Run custom test
./run_multiple_latency_tests.sh <broker-ip> 16,256 1000,10000 30 c8g.large
```

## Interpreting Results

### Typical Patterns

1. **Latency increases with rate**: As message rate increases, latency typically rises due to queuing
2. **Larger messages = higher latency**: More data takes longer to transfer
3. **P95/P99 divergence**: Significant gap between median and p99 indicates jitter or tail latency issues
4. **Bandwidth scaling**: Should increase linearly with rate until hitting limits

### Performance Expectations

For c8g.large instances with LavinMQ:

- **Low latency baseline**: < 1ms at low rates (10-1000 msgs/s)
- **Moderate load**: 1-5ms at medium rates (10,000-50,000 msgs/s)
- **High load**: 5-20ms approaching max throughput (100,000+ msgs/s)

Actual performance varies based on:

- Instance type and network bandwidth
- Message size and complexity
- LavinMQ version and configuration
- Number of producers/consumers
