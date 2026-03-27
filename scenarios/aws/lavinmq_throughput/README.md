# LavinMQ Throughput Benchmark

This scenario provisions AWS infrastructure, installs LavinMQ, and runs a single configurable
`lavinmqperf` performance test against the broker.

## What It Does

1. **Provisions AWS Infrastructure**:
   - VPC with subnet and security groups
   - One broker instance with LavinMQ installed and running
   - One or more load generator instances with LavinMQ tools installed

2. **Runs a Performance Test**:
   - Executes the command provided via the `perftest_command` variable on the load generator
   - Captures output directly in the Terraform apply log

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
TF_VAR_ami_arch="arm64"          # or "amd64"
TF_VAR_ubuntu_code_name="noble"  # Ubuntu version

# Benchmark server
TF_VAR_broker_volume_size=8      # Root disk size in GB
TF_VAR_load_generator_volume_size=8  # Root disk size in GB
TF_VAR_lavinmq_version=""        # Empty = latest, or specify a version
```

## Usage

### 1. Initialize Terraform

```bash
cd scenarios/aws/lavinmq_throughput
terraform init
```

### 2. Create the setup and run a performance test

Run the performance test by specifying the `perftest_command` variable:

```bash
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
```

### 3. Re-run the same performance test

To re-run without changing parameters, force-replace the `perftest` resource:

```bash
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16" \
  -replace="module.performance_test[0].terraform_data.perftest"
```

### 4. Run a different performance test

Change any parameter and Terraform will automatically replace the `perftest` resource:

```bash
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 60 -x 1 -y 1 -s 16"
```

### 5. Clean up resources

```bash
dotenv terraform destroy
```
