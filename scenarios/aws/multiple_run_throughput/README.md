# Multiple Run Throughput Benchmark

This scenario runs multiple sequential throughput tests with different message sizes against a LavinMQ broker instance,
automatically collecting and summarizing the results in a markdown table.

## What It Does

1. **Provisions AWS Infrastructure**:
   - VPC with subnet and security groups
   - One broker instance with LavinMQ installed and running
   - One load generator instance with LavinMQ tools installed

2. **Runs Sequential Tests**:
   - For each configured message size:
     - Purges the test queue via LavinMQ HTTP API
     - Runs `lavinmqperf throughput` test
     - Captures publish and consume rates

3. **Generates Results**:
   - Creates a markdown summary table with results for all message sizes
   - Stores results on the load generator instance at `/home/ubuntu/throughput_results.md`
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
TF_VAR_ami_arch = "arm64"                         # or "amd64"
TF_VAR_ubuntu_code_name = "noble"                 # Ubuntu version

# Benchmark server
TF_VAR_broker_volume_size = 8                     # Root disk size in GB
TF_VAR_load_generator_volume_size = 8             # Root disk size in GB
TF_VAR_lavinmq_version = ""                       # Empty = latest, or specify version

# Test configuration
TF_VAR_message_sizes = [16, 64, 256, 512, 1024]   # Message sizes in bytes
TF_VARtest_duration = 120                         # Duration of each test in seconds
```

## Usage

### 1. Initialize Terraform

```bash
cd scenarios/aws/multiple_run_throughput
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
dotenv terraform apply -var='message_sizes=[16,64,256,512,1024,2048]'
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
results_file_path = "/home/ubuntu/throughput_results.md"
ssh_view_results_command = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com 'cat /home/ubuntu/throughput_results.md'"
scp_download_results_command = "scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com:/home/ubuntu/throughput_results.md ./throughput_results.md"
```

## Viewing Results

### View results remotely via SSH

Use the provided command from outputs:

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns> 'cat /home/ubuntu/throughput_results.md'
```

### Download results to local machine

```bash
scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>:/home/ubuntu/throughput_results.md ./results.md
```

## Example Output

The generated markdown file will look like this (example results):

```markdown
# LavinMQ Throughput Test Results

Test Date: 2026-02-23 14:30:00 UTC
Broker Instance Type: c8g.large
LavinMQ Version: 2.5.0

## Results

| Size (bytes) | Avg. Pub. Rate (msgs/s) | Avg. Con. Rate (msgs/s) | Pub. Bandwidth (MiB/s) | Con. Bandwidth (MiB/s) |
|-------------:|------------------------:|------------------------:|-----------------------:|-----------------------:|
|           16 |               1,234,567 |               1,230,123 |                  18.86 |                  18.79 |
|           64 |               1,100,000 |               1,098,765 |                  67.14 |                  67.06 |
|          256 |                 950,000 |                 948,500 |                 232.01 |                 231.65 |
|          512 |                 800,000 |                 798,900 |                 390.62 |                 389.78 |
|         1024 |                 650,000 |                 649,000 |                 634.76 |                 633.78 |

## Test Configuration

- Duration: 120 seconds (`-z 120`)
- Producers: 1 (`-x 1`)
- Consumers: 1 (`-y 1`)
- Message sizes: 16,64,256,512,1024 bytes
- Queue: perf-test
```

**Note:** Actual test results are stored at `/home/ubuntu/throughput_results.md` on the load generator instance. Use the provided SSH or SCP commands from Terraform outputs to view or download them.

## Test Details

### What Each Test Does

1. **Queue Purge**: Clears any remaining messages from previous tests via HTTP API

   ```bash
   DELETE http://<broker-ip>:15672/api/queues/%2F/perf-test/contents
   ```

2. **Throughput Test**: Runs performance test with specified parameters

   ```bash
   lavinmqperf throughput -z <duration> -x 1 -y 1 -s <size> --uri=amqp://perftest:perftest@<broker-ip>
   ```

3. **Result Parsing**: Extracts "Average publish rate" and "Average consume rate" from output

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
- SSH to load generator and check: `cat /home/ubuntu/throughput_results.md`

### Version fetch fails

- Shows as "Unknown (failed to fetch)" if HTTP API is not accessible
- Tests will still run, only the version display is affected

## Script Location

The test orchestration script is located at:
`../../../scripts/run_multiple_throughput_tests.sh`

It can be run manually on the load generator for additional tests:

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>
./run_multiple_throughput_tests.sh <broker-private-ip> [sizes] [duration] [broker_instance_type]

# Example:
./run_multiple_throughput_tests.sh 172.16.10.5 16,64,256 60 c8g.large
```

## Re-running Tests

### Option 1: Taint the Test Resource (Recommended)

Force Terraform to re-run just the test execution without destroying/recreating instances:

```bash
# Mark the test resource for re-execution
terraform taint 'terraform_data.multiple_throughput_tests'

# Apply to re-run tests
dotenv terraform apply
```

This will only re-execute the test script without touching the broker or load generator instances.

### Option 2: Use -replace Flag

Directly replace the test resource in one command:

```bash
dotenv terraform apply -replace='terraform_data.multiple_throughput_tests'
```

### Option 3: Change Test Parameters

Modify test configuration to trigger automatic re-run:

```bash
# Change message sizes
dotenv terraform apply -var='message_sizes=[16,64,256]'

# Or change test duration
dotenv terraform apply -var="test_duration=60"
```

Terraform will detect the change in `triggers_replace` and automatically re-run the tests.

### Option 4: SSH Manually

Run the script directly on the load generator:

```bash
# SSH into load generator
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns>

# Execute the script
./run_multiple_throughput_tests.sh <broker-private-ip> 16,64,256,512,1024 120 c8g.large

# View results
cat /home/ubuntu/throughput_results.md
```
