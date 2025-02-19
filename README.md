# lavinmq-benchmark

Run automate benchmark against LavinMQ with help of CloudAMQP Terraform Provider.

> [!CAUTION]
> Currently missing correct internal URL from the backend to make correct AMQP message publish/delivery.

## Prerequisites

- ***Golang***: Install Golang, follow [Golang's installation guide](https://go.dev/doc/install)
- ***Terraform*** Install Terraform (>=0.12), follow [Terraform's installation guide](https://developer.hashicorp.com/terraform/install)
- Create a personal access key on https://console.cloudamqp.com (or locally)

## Environmental variables

The environmental variables can either be set in the command, export or via a file.

- `CLOUDAMQP_APIKEY` always need to be set as an environmental variables
- `CLOUDAMQP_BASEURL` can be used to run locally (http\://localhost:9393 with local API key).
Default set to `https://customer.cloudamqp.com` by the provider.

To use dotenv file see: [Handbook](https://github.com/84codes/handbook/blob/main/terraform/run-locally.md#authentication)

## Configuration

Change the local variables in `./configuraiton/locals.tf` to change the behavior

- ***benchmark_instance_plan*** subscription plan for the server to be benchmarked
- ***benchmark_instance_version*** LavinMQ version used by the benchmark server. (Set to null to
get latest)
- ***perftest_instance_plan*** subscription plan for the server running `lavinmqperftest`
- ***region*** provider and region to host everything
- ***tags*** tag all the resources
- ***perftest*** the perftest command to be used (leave out --uri= parameter, this will be assinged
during the run)

## Run

### Initial provider

Before running the benchmark the providers needs to be initialized. This will dowload the latest
version of the CloudAMQP provider released to
[Terraform registry](https://registry.terraform.io/providers/cloudamqp/cloudamqp)
and other providers needed.

`terraform init`

### Create servers and run perftest

To run the benchmark, use the apply command. A VPC and necessary servers will be created. Once all
servers have been bootstrapped and running. The benchmark will start and end with a summary output
to the terminal.

`dotenv terraform apply`

### Run a new benchmark

The local execution of new SSH command, will be triggered if the perftest command is changed. I.e.
any of the parameters are changed and then re-use the Terraform apply command.

`dotenv terraform apply`

### Re-run same benchmark

To re-run the same benchmark the `terraform_data.local_exec` need to be destroyed and created again.
This can be done with two commands.

`dotenv terraform destroy -target terraform_data.local_exec`
`dotenv terraform apply`

### Cleanup

Cleanup all the resources in the benchmark with destroy.

`dotenv terraform destroy`

### Result

Currently only displayed in the terminal output after each run from the Terraform resource
`terraform_data.local_exec` and will look like.

```
terraform_data.local_exec (local-exec): Summary:
terraform_data.local_exec (local-exec): Average publish rate: 245195.7 msgs/s
terraform_data.local_exec (local-exec): Average consume rate: 220257.5 msgs/s
```

## Ongoing work

- Run multiple benchmarks servers (multiple subscriptions plan or versions)
- Better presentation of the results.
- Any advantages running perftest on a standalone AWS, Azure, GCE server (instead of using another
one create via CloudAMQP)
