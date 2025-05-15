# How to Run the LavinMQ Benchmark Tool

The LavinMQ Benchmark Tool allows you to test and measure the performance of LavinMQ using
predefined scenarios. Follow the steps below to set up and run the benchmarks.

## Prerequisites

1. Ensure you have the required environment variables defined. Use the provided template file
  `./modules/provider/aws/env_template.env` to configure them.
2. Remember that Terraform requires variables to be prefixed with `TF_VAR_` and they are
  case-sensitive.

## LavinMQ performance tester

The performance test is done by lavinmqperf`. More information about how to use it can be
found in the [documentation](https://lavinmq.com/documentation/lavinmqperf).

## Steps to Run the Benchmark

### 1. Initialize the Environment

Navigate to the desired scenario directory (e.g., `./scenarios/aws/lavinmq_throughput`) and
initialize the Terraform AWS provider and modules:

```console
dotenv terraform init
```

### 2. Create the setup and finish with performance test

Run the performance test by specifying the perftest_command variable when applying the Terraform
configuration:

```console
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
```

### 3. Re-run the same performance test

To re-run the same test, replace the terraform_data.perftest resource using the following command:

```console
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16" \
-replace="module.performance_test[0].terraform_data.perftest"
```

### 4. Run a different performance test

If you want to modify the test parameters (e.g., change the duration from 120 seconds to 60 seconds),
Terraform will automatically replace the terraform_data.perftest resource and start a new test:

```console
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 60 -x 1 -y 1 -s 16"
```

### 5. Clean up resources

To tear down all resources and clean up the environment, run:

```console
dotenv terraform destroy
```

## Logging

Terraform supports provider logging for detailed output. You can enable logging by setting the
`TF_LOG_PROVIDER` environment variable to one of the following severity levels:
[INFO, DEBUG, WARN, ERROR, TRACE].

```console
export TF_LOG_PROVIDER=DEBUG
```

This will provide more detailed logs during the execution of Terraform commands
