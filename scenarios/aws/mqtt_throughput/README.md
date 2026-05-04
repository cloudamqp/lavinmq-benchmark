# MQTT Throughput Benchmark

This scenario runs multiple sequential MQTT throughput tests with different message sizes against a LavinMQ broker
instance, automatically collecting raw results as CSV/JSON and computing aggregated (median) summaries.

## What It Does

1. **Provisions AWS Infrastructure**:
   - VPC with subnet and security groups
   - One broker instance with LavinMQ installed and running
   - One load generator instance with LavinMQ tools and MQTT benchmark tools (`emqtt-bench`, `mqttloader`) installed

2. **Runs Sequential Tests**:
   - For each run (repeated `num_runs` times):
     - For each configured message size:
       - Runs `mqtt_bench.sh throughput` test via MQTT v3.1.1
       - Captures publish and consume rates

3. **Generates Results**:
   - Raw per-run results saved as CSV at `/home/ubuntu/mqtt_throughput_results.csv`
   - Test configuration saved as JSON at `/home/ubuntu/mqtt_throughput_results.json`
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
TF_VAR_load_generator_instance_type="c8g.large"
TF_VAR_load_generator_name="Benchmark-loadgen"
```

### Optional Variables (with defaults)

```bash
# Infrastructure
TF_VAR_ami_arch="arm64"               # or "amd64"
TF_VAR_ubuntu_code_name="noble"       # Ubuntu version

# Benchmark server
TF_VAR_broker_volume_size=20          # Root disk size in GB
TF_VAR_load_generator_volume_size=8   # Root disk size in GB
TF_VAR_lavinmq_version=""             # Empty = latest, or specify a version

# Test configuration
TF_VAR_message_sizes=[16, 64, 256, 512, 1024]  # Message sizes in bytes
TF_VAR_test_duration=60                        # Duration of each test in seconds
TF_VAR_num_runs=3                              # Number of runs per size (results are aggregated as median)
```

Non-secret defaults are tracked in `defaults.env`. Override any value in your local `.env`.

## Usage

### 1. Initialize Terraform

```bash
cd scenarios/aws/mqtt_throughput
terraform init
```

### 2. Run the Benchmark

Using dotenv (recommended):

```bash
dotenv -f defaults.env -f .env -- terraform apply
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
dotenv -f defaults.env -f .env -- terraform apply -var='message_sizes=[16,64,256]'
```

Override test duration and number of runs:

```bash
dotenv -f defaults.env -f .env -- terraform apply -var="test_duration=30" -var="num_runs=5"
```

### 4. Re-run tests without reprovisioning

Force-replace only the test resource:

```bash
dotenv -f defaults.env -f .env -- terraform apply -replace='terraform_data.mqtt_throughput_tests'
```

### 5. Clean up resources

```bash
dotenv -f defaults.env -f .env -- terraform destroy
```

## Outputs

After successful completion, Terraform provides:

```console
broker_public_dns            = "ec2-xx-xx-xx-xx.compute-1.amazonaws.com"
load_generator_public_dns    = "ec2-yy-yy-yy-yy.compute-1.amazonaws.com"
results_file_path            = "/home/ubuntu/mqtt_throughput_results.csv"
results_config_path          = "/home/ubuntu/mqtt_throughput_results.json"
ssh_view_results_command     = "ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com 'cat /home/ubuntu/mqtt_throughput_results.csv'"
scp_download_results_command = "scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@ec2-yy-yy-yy-yy.compute-1.amazonaws.com:'/home/ubuntu/mqtt_throughput_results.csv /home/ubuntu/mqtt_throughput_results.json' ."
```

## Viewing / Downloading Results

### View CSV remotely via SSH

```bash
ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts \
  ubuntu@<load-generator-dns> 'cat /home/ubuntu/mqtt_throughput_results.csv'
```

### Download both result files

```bash
scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts \
  ubuntu@<load-generator-dns>:'/home/ubuntu/mqtt_throughput_results.csv /home/ubuntu/mqtt_throughput_results.json' .
```

### Aggregate results locally

After downloading, run the aggregation script to compute median values across runs and produce the summary markdown:

```bash
python scripts/aggregate_results.py \
  --version 2.7.0 \
  --mqtt-throughput-dir ./raw-results/mqtt-throughput \
  --output-dir results
```

This writes `results/v2.7.0/mqtt_throughput.md` and copies the raw CSV/JSON into
`results/v2.7.0/mqtt_throughput/`.

## Raw Result Format

### CSV (`mqtt_throughput_results.csv`)

```CSV
Run,Size,PubRate,ConRate,PubBW,ConBW
1,16,512340,511200,0.00,0.00
1,64,498000,497100,0.03,0.03
...
```

- **Run**: Run number (1 to `num_runs`)
- **Size**: Message size in bytes
- **PubRate** / **ConRate**: Publish / consume rate in msgs/s
- **PubBW** / **ConBW**: Publish / consume bandwidth in MiB/s

### JSON (`mqtt_throughput_results.json`)

```json
{
  "instance_type": "c8g.large",
  "lavinmq_version": "2.7.0",
  "duration": 60,
  "producers": 1,
  "consumers": 1,
  "runs": 3,
  "sizes": [16, 64, 256, 512, 1024]
}
```

## Test Details

### What Each Test Does

1. **Throughput Test**: Runs MQTT performance test with specified parameters

   ```bash
   mqtt_bench.sh throughput -z <duration> -x 1 -y 1 -s <size> \
     --uri=mqtt://perftest:perftest@<broker-ip>
   ```

   - `-z`: Test duration in seconds
   - `-x 1`: Single publisher
   - `-y 1`: Single subscriber
   - `-s`: Message size in bytes

2. **Result Parsing**: Extracts average publish and consume rates from output and computes MiB/s bandwidth.

### Network Configuration

The scenario creates security group rules allowing:

- **SSH (port 22)**: From anywhere (0.0.0.0/0) for management
- **MQTT (port 1883)**: Within VPC for message traffic
- **HTTP API (port 15672)**: Within VPC for version discovery

## Troubleshooting

### Tests fail to connect to broker

- Ensure the security group allows MQTT traffic on port 1883 within the VPC
- Check the broker is running: `ssh ubuntu@<broker-dns> 'sudo systemctl status lavinmq'`

### MQTT tools installation fails

The `install_mqtt_tools.sh` script builds `emqtt-bench` from source and downloads `mqttloader`.
Both steps use retry logic (up to 5 attempts with backoff) to handle transient network issues
such as 504 gateway timeouts from GitHub.
