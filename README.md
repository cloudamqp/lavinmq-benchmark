# How to Run the LavinMQ Benchmark Tool

The LavinMQ Benchmark Tool allows you to test and measure the performance of LavinMQ using
predefined scenarios. Follow the steps below to set up and run the benchmarks.

## Prerequisites

1. Terraform: Install Terraform (>= 1.3.0). Follow [Terraform's installation guide](https://developer.hashicorp.com/terraform/install).

## Variables

You can provide variables using either a standard Terraform variable file or by loading them from a
`.env` file with [a dotenv loader](https://github.com/bkeepers/dotenv).

### AWS provider

The AWS provider requires credentials for access. Set these as environment variables:

```shell
export AWS_ACCESS_KEY=***
export AWS_SECRET_KEY=***
```

### Operating system

By default this will run the benchmarks on Ubuntu but there is also support to run it on FreeBSD.

Here are the additional variables needed to make that happen

```
os_type         = "freebsd"
freebsd_version = "14.2"    # optional, defaults to 14.2
ami_arch        = "amd64"   # or "arm64" 
```

### Using `.tfvars` file

Terraform can automatically load variables from files as described in the [Terraform documentation](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files).

1. Define the required variables using the template at
   `./modules/provider/aws/template/terraform_tfvars.txt`.
2. Create a `terraform.tfvars` or `terraform.auto.tfvars` file in your scenario directory before
   running Terraform.

### Using dotenv

You can use a dotenv loader (for example, for Golang, Ruby, Node.js, etc.) to read variables from a
`.env` file and set them as environment variables.

1. Define the required environment variables using the template at
   `./modules/provider/aws/variable_template/env.txt`.
2. When loading these variables, ensure each is prefixed with `TF_VAR_` and note that variable names
   are case-sensitive for Terraform.

## LavinMQ performance tester

The performance test is done using `lavinmqperf`. More information about how to use it can be
found in the [documentation](https://lavinmq.com/documentation/lavinmqperf).

## Steps to Run the Benchmark

### 1. Initialize the Environment

Navigate to the desired scenario directory (e.g., `./scenarios/aws/lavinmq_throughput`) and
initialize the Terraform AWS provider and modules:

Automatically read variables from `terraform.auto.tfvars` file.

```shell
terraform init
```

Read variables form `terraform.tfvars` file.

```shell
terraform init -var="terraform.tfvars"
```

Read variables from `.env` file

```shell
dotenv terraform init
```

Rest of the examples will be presented using `dotenv` to load the variables required.

### 2. Create the setup and finish with performance test

Run the performance test by specifying the perftest_command variable when applying the Terraform
configuration:

```shell
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
```

### 3. Re-run the same performance test

To re-run the same test, replace the terraform_data.perftest resource using the following command:

```shell
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16" \
-replace="module.performance_test[0].terraform_data.perftest"
```

### 4. Run a different performance test

If you want to modify the test parameters (e.g., change the duration from 120 seconds to 60 seconds),
Terraform will automatically replace the terraform_data.perftest resource and start a new test:

```shell
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 60 -x 1 -y 1 -s 16"
```

### 5. Clean up resources

To tear down all resources and clean up the environment, run:

```shell
dotenv terraform destroy
```

## Logging

Terraform supports provider logging for detailed output. You can enable logging by setting the
`TF_LOG_PROVIDER` environment variable to one of the following severity levels:
[INFO, DEBUG, WARN, ERROR, TRACE].

```shell
export TF_LOG_PROVIDER=DEBUG
```

This will provide more detailed logs during the execution of Terraform commands
