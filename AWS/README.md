# Standalone AWS servers

## Environmental variables

There is a template on which enviromental variables that are needed.
`./env_template`

> [!NOTE]
> For Terraform to read the variables used in the configuration. They need to be prefixed
> with `TF_VAR_` and are case sensitive.

## Run

Initialize the AWS provider and modules with:

`dotenv terraform init`

The perfomance test command is invoked as a input variable called `perftest_command`
and can be assigned when running `terraform apply`.

`dotenv terraform apply -var="perftest_command=lavinmqperf throughput -z 10 -x 1 -y 1 -s 16"`

To re-run the same test, include a replace of the resource invoking the command.

```console
dotenv terraform apply -target terraform_data.perftest \
-var="perftest_command=lavinmqperf throughput -z 10 -x 1 -y 1 -s 16"
```

To clean up and tear down all resources.
`dotenv terraform destroy`

## Ensure scripts

Two scripts added to ensure `LavinMQ` is running and `lavinmqperf` command can be found.
The server set both install `LavinMQ` in the cloud init phase. This can take time to finish
before the perftest command is invoked. To ensure the new user exists and command can be used, these
checks are necessary.
