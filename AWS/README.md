# Standalone AWS servers

## Environmental variables

There is a template on which enviromental variables that are needed.
`./env_template`

> [!NOTE]
> For Terraform to read the variables used in the configuration. They need to be prefixed
> with `TF_VAR_` and are case sensitive.

## Run

The performance test is done by lavinmqperf`. More information about how to use it can be
found in the [documentation](https://lavinmq.com/documentation/lavinmqperf).

### Initalize

Initialize the AWS provider and modules with:

```console
dotenv terraform init
```

### Create the setup and finish with performance test

The perfomance test command is invoked as a input variable called `perftest_command`
and can be assigned when running `terraform apply`.

```console
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
```

### Re-run the same performance test

To re-run the same test, include a replace of the `terraform_data.perftest` resource.
This is the resource that invokes the command.

```console
dotenv terraform apply -replace terraform_data.perftest \
-var="perftest_command=lavinmqperf throughput -z 120 -x 1 -y 1 -s 16"
```

### Run another performance test

If any command parameters are changed. An automatic replace will be triggered of 
`terraform_data.perftest` resource and a new performance test will start.
Example: change running time from 120 to 60.

```console
dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 60 -x 1 -y 1 -s 16"
```

### Clean up

To clean up and tear down all resources.

```console
dotenv terraform destroy
```

## Ensure scripts

Two scripts added to ensure `LavinMQ` is running and `lavinmqperf` command can be found.
All servers install `LavinMQ` in the cloud init phase. This can take time to finish
before the perftest command is invoked. To ensure the new user exists and command can be used, these
checks are necessary.

## Logging

Terraform support provider logging for more output than the is initial displayed in the terminal.
This can be set as an environmental variable `TF_LOG_PROVIDER` and support the common severity levels.
`[INFO, DEBUG, WARN, ERROR, TRACE]`.
