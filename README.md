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

## Logging

Enable detailed Terraform provider logs by setting:

```shell
export TF_LOG_PROVIDER=DEBUG
```

Accepted levels: `INFO`, `DEBUG`, `WARN`, `ERROR`, `TRACE`.
