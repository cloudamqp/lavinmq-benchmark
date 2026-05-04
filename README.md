# LavinMQ Benchmark Tool

Infrastructure-as-code benchmarking tool for [LavinMQ](https://lavinmq.com), using Terraform to
provision AWS resources and [`lavinmqperf`](https://lavinmq.com/documentation/lavinmqperf) to run
performance tests.

## Prerequisites

- Terraform >= 1.3.0 — [installation guide](https://developer.hashicorp.com/terraform/install)
- AWS credentials with permission to create EC2 and VPC resources
- An SSH key pair for instance access

## Scenarios

### [`lavinmq_throughput`](scenarios/aws/lavinmq_throughput/)

Provisions a broker and one or more load generator instances, then runs a single user-supplied
`lavinmqperf` command. Useful for ad-hoc throughput or latency measurements where you control the
exact test parameters.

### [`multiple_run_throughput`](scenarios/aws/multiple_run_throughput/)

Runs sequential AMQP throughput tests across a configurable set of message sizes, repeated N times.
Produces a CSV file of raw per-run results and a JSON config file on the load generator. Aggregated
(median) summaries are written to `results/v{version}/throughput.md` by `scripts/aggregate_results.py`.

### [`multiple_run_latency`](scenarios/aws/multiple_run_latency/)

Runs sequential AMQP latency tests across a configurable set of message sizes and rate limits,
repeated N times. Produces a CSV file of raw per-run results and a JSON config file on the load
generator. Aggregated (median) summaries are written to `results/v{version}/latency_P95.md` and
`latency_P99.md` by `scripts/aggregate_results.py`.

### [`mqtt_throughput`](scenarios/aws/mqtt_throughput/)

Runs sequential MQTT throughput tests across a configurable set of message sizes, repeated N times.
Installs `emqtt-bench` and `mqttloader` on the load generator. Produces a CSV file of raw per-run
results and a JSON config file on the load generator. Aggregated (median) summaries are written to
`results/v{version}/mqtt_throughput.md` by `scripts/aggregate_results.py`.

## Configuration

Variables can be supplied in three ways:

**`terraform.auto.tfvars`** — loaded automatically by Terraform:

```shell
terraform apply
```

**`terraform.tfvars`** — loaded explicitly:

```shell
terraform apply -var-file="terraform.tfvars"
```

**`.env` file via [dotenv](https://github.com/bkeepers/dotenv)** — environment variables prefixed
with `TF_VAR_`:

```shell
dotenv terraform apply
```

Use the templates in `modules/providers/aws/variables_template/` as a starting point:

- `terraform_tfvars.txt` — for `.tfvars` files
- `env.txt` — for `.env` files

AWS credentials must be set as environment variables regardless of the method used:

```shell
export AWS_ACCESS_KEY=***
export AWS_SECRET_KEY=***
```

## CI / Parallel Benchmarks

The [Benchmark](../../actions/workflows/benchmark.yml) GitHub Actions workflow provisions
infrastructure, runs benchmarks across all supported instance types in parallel, aggregates the
results into markdown summary files, and opens a pull request against `main` with the results
committed to a `results/v{version}` branch.

### Triggering a run

**Via the GitHub UI:** go to **Actions → Benchmark → Run workflow**, fill in the version and pick a scenario.

**Via the GitHub CLI:**

```shell
# Run all benchmarks (AMQP throughput, AMQP latency, MQTT throughput) for all instance types
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=all

# Latency only
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=latency

# AMQP throughput only
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=throughput

# MQTT throughput only
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=mqtt-throughput

# Run from a specific branch (e.g. when testing workflow changes)
gh workflow run benchmark.yml \
  -r my-branch \
  -f lavinmq_version=2.7.0 \
  -f scenarios=all
```

Results are committed to `results/v{version}/` and a pull request is created (or updated if one
already exists for that version).

### Re-running specific broker instance types

All three workflows accept an optional `brokers` input — a comma-separated list of broker instance
types to run. When omitted or empty, all instance types are benchmarked. This is useful for
re-running a single instance type that failed without triggering the full suite.

```shell
# Re-run latency benchmark for a single instance type
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=latency \
  -f brokers="c8g.large"

# Re-run latency benchmark for multiple specific instance types
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=latency \
  -f brokers="c8g.large,t4g.medium"
```

The individual `benchmark-latency.yml`, `benchmark-throughput.yml`, and `benchmark-mqtt-throughput.yml`
workflows can also be triggered directly in the same way if you want to skip the aggregate/PR step.

## Logging

Enable detailed Terraform provider logs by setting:

```shell
export TF_LOG_PROVIDER=DEBUG
```

Accepted levels: `INFO`, `DEBUG`, `WARN`, `ERROR`, `TRACE`.
