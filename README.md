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

Runs sequential throughput tests across a configurable set of message sizes. Produces a markdown
summary table (publish and consume rates per message size) stored on the load generator and
displayed as Terraform output.

### [`multiple_run_latency`](scenarios/aws/multiple_run_latency/)

Runs sequential latency tests across a configurable set of message sizes and rate limits. Produces
one markdown table per message size showing latency percentiles (min, median, p75, p95, p99) and
bandwidth, stored on the load generator and displayed as Terraform output.

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

### Required secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key with EC2 / VPC create permissions |
| `AWS_SECRET_ACCESS_KEY` | Corresponding AWS secret key |
| `BENCHMARK_SSH_PRIVATE_KEY` | Private half of the key pair used by Terraform to connect to instances |
| `BENCHMARK_SSH_PUBLIC_KEY` | Public half of the key pair (deployed to instances) |

### Triggering a run

**Via the GitHub UI:** go to **Actions → Benchmark → Run workflow**, fill in the version and pick a scenario.

**Via the GitHub CLI:**

```shell
# Run both latency and throughput benchmarks
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=all

# Latency only
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=latency

# Throughput only
gh workflow run benchmark.yml \
  -f lavinmq_version=2.7.0 \
  -f scenarios=throughput
```

Results are committed to `results/v{version}/` and a pull request is created (or updated if one
already exists for that version).

## Logging

Enable detailed Terraform provider logs by setting:

```shell
export TF_LOG_PROVIDER=DEBUG
```

Accepted levels: `INFO`, `DEBUG`, `WARN`, `ERROR`, `TRACE`.
