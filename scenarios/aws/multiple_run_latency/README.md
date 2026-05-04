# Multiple Run Latency Benchmark

This scenario runs multiple sequential latency tests with different message sizes and rate limits against a LavinMQ
broker instance, automatically collecting raw results as CSV/JSON and computing aggregated (median) summaries.

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
   - Raw per-run results saved as CSV at `/home/ubuntu/latency_results.csv`
   - Test configuration saved as JSON at `/home/ubuntu/latency_results.json`
   - Aggregated (median) summaries are computed by `scripts/aggregate_results.py`

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
TF_VAR_message_sizes = [16, 64, 256, 512, 1024, 4096, 16384, 65536]        # Message sizes in bytes
TF_VAR_rate_limits = [10, 100, 1000, 10000, 50000, 100000, 200000, 500000] # Rate limits in msgs/s
TF_VAR_test_duration = 120                                                 # Duration of each test in seconds
TF_VAR_num_runs = 3                                                        # Number of runs per combination, default 1

# Optional: per-message-size rate limit overrides.
# Sizes not listed fall back to TF_VAR_rate_limits.
# This ensures no rate limit exceeds the instance's measured max throughput,
# keeping latency results meaningful and comparable across instance types.
TF_VAR_per_size_rate_limits={"16":[10,100,1000,5000,10000,50000,100000,250000,500000],"64":[10,100,1000,5000,10000,50000,100000,250000,500000],"256":[10,100,1000,5000,10000,50000,100000,250000],"512":[10,100,1000,5000,10000,50000,100000],"1024":[10,100,1000,5000,10000,50000],"4096":[10,100,1000,5000,10000],"16384":[10,100,1000,5000],"65536":[10,100,1000]}
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
broker_public_dns            = "ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
load_generator_public_dns    = "ec2-yy-yy-yy-yy.compute-1.amazonaws.com"
results_file_path            = "/home/ubuntu/latency_results.csv"
results_config_path          = "/home/ubuntu/latency_results.json"
ssh_view_results_command     = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com 'cat /home/ubuntu/latency_results.csv'"
scp_download_results_command = "scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com:'/home/ubuntu/latency_results.csv /home/ubuntu/latency_results.json' ."
```

## Viewing / Downloading Results

### View CSV remotely via SSH

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts \
  ubuntu@<load-generator-dns> 'cat /home/ubuntu/latency_results.csv'
```

### Download both result files

```bash
scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts \
  ubuntu@<load-generator-dns>:'/home/ubuntu/latency_results.csv /home/ubuntu/latency_results.json' .
```

### Aggregate results locally

After downloading, run the aggregation script to compute median values across runs and produce the summary markdown:

```bash
python scripts/aggregate_results.py \
  --version 2.7.0 \
  --latency-dir ./raw-results/latency \
  --output-dir results
```

This writes `results/v2.7.0/latency_P95.md` and `results/v2.7.0/latency_P99.md` and copies the raw CSV/JSON into
`results/v2.7.0/latency/`.

## Raw Result Format

### CSV (`latency_results.csv`)

```CSV
Run,Size,RateLimit,Min,Median,P75,P95,P99,PubRate,PubBW,ConBW
1,16,10,0.12,0.23,0.34,0.45,0.56,10,0.00,0.00
1,16,100,0.23,0.34,0.45,0.56,0.67,100,0.00,0.00
...
```

- **Run**: Run number (1 to `num_runs`)
- **Size**: Message size in bytes
- **RateLimit**: Rate limit in msgs/s
- **Min / Median / P75 / P95 / P99**: Latency percentiles in milliseconds
- **PubRate**: Achieved publish rate in msgs/s
- **PubBW** / **ConBW**: Publish / consume bandwidth in MiB/s

### JSON (`latency_results.json`)

```json
{
  "instance_type": "c8g.large",
  "lavinmq_version": "2.7.0",
  "duration": 20,
  "producers": 1,
  "consumers": 1,
  "runs": 3,
  "queue": "perf-test",
  "sizes": [16, 64, 256, 512, 1024, 4096, 16384, 65536],
  "rate_limits": [10, 100, 1000, 10000, 50000, 100000, 200000, 500000],
  "per_size_rate_limits": {}
}
```

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
