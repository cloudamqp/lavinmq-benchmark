# MQTT Throughput Benchmark

This scenario provisions AWS infrastructure, installs LavinMQ and MQTT benchmark tools, and runs sequential
MQTT throughput tests with different message sizes against the broker, summarizing results in a markdown table.

## What It Does

1. **Provisions AWS Infrastructure**:
   - VPC with subnet and security groups (including MQTT port 1883)
   - One broker instance with LavinMQ installed and running
   - One load generator instance with LavinMQ tools and MQTT benchmark tools (`emqtt-bench`, `mqttloader`) installed

2. **Runs Sequential Tests**:
   - For each configured message size, runs an MQTT throughput test via the `mqtt_bench.sh` wrapper (driving `emqtt-bench`)
   - Captures publish and consume rates and computes bandwidth

3. **Generates Results**:
   - Writes a markdown summary to `/home/ubuntu/mqtt_throughput_results.md` on the load generator
   - Outputs SSH/SCP commands to view or download the file

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
TF_VAR_load_generator_instance_type="c8g.large"
TF_VAR_load_generator_name="Benchmark-loadgen"
```

### Optional Variables (with defaults)

```bash
# Infrastructure
TF_VAR_ami_arch="arm64"               # or "amd64"
TF_VAR_ubuntu_code_name="noble"       # Ubuntu version

# Benchmark server
TF_VAR_broker_volume_size=8           # Root disk size in GB
TF_VAR_load_generator_volume_size=8   # Root disk size in GB
TF_VAR_lavinmq_version=""             # Empty = latest, or specify a version

# Test configuration
TF_VAR_message_sizes=[16,64,256,512,1024]   # Message sizes in bytes
TF_VAR_test_duration=120                    # Duration of each test in seconds
```

## Usage

### 1. Initialize Terraform

```bash
cd scenarios/aws/mqtt_throughput
terraform init
```

### 2. Create the setup and run the throughput tests

```bash
dotenv terraform apply
```

### 3. Re-run the tests

Force-replace the test resource without recreating instances:

```bash
dotenv terraform apply -replace='terraform_data.mqtt_throughput_tests'
```

### 4. Change test parameters

Change any parameter and Terraform will automatically replace the test resource:

```bash
dotenv terraform apply -var='message_sizes=[16,64,256]' -var='test_duration=60'
```

### 5. View results

After apply finishes, use the SSH/SCP commands from the Terraform outputs:

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@<load-generator-dns> 'cat /home/ubuntu/mqtt_throughput_results.md'
```

### 6. Clean up resources

```bash
dotenv terraform destroy
```
