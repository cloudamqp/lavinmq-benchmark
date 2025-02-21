# lavinmq-benchmark

Run automate benchmark against LavinMQ with help of CloudAMQP Terraform Provider.

## Prerequisites

- ***Golang***: Install Golang, follow [Golang's installation guide](https://go.dev/doc/install)
- ***Terraform*** Install Terraform (>=0.12), follow [Terraform's installation guide](https://developer.hashicorp.com/terraform/install)
- Create a personal access key on https://console.cloudamqp.com (or locally)

## Environmental variables

The environmental variables can either be set in the command, export or via environmental file.

- `CLOUDAMQP_APIKEY` always need to be set as an environmental variables

To use dotenv or use local environment file see: [Handbook](https://github.com/84codes/handbook/blob/main/terraform/run-locally.md#apply-the-configuration)

## Configuration

Change the local variables in `./configuraiton/locals.tf` to change the behavior

- ***benchmark_plan:*** subscription plan for the server to be benchmarked
- ***benchmark_version:*** LavinMQ version(s) used by the benchmark server(s). (Set to null to
get latest)
- ***perftest_plan:*** subscription plan for the server running `lavinmqperftest`
- ***region:*** provider and region to host everything
- ***tags:*** tag all the resources
- ***perftest:*** the perftest command to be used (leave out --uri= parameter, this will be assinged
during the run)


To run multiple benchmark servers, add more then one version to `benchmark_version`.

Benchmark on one server with latest available version
```
benchmark_versions = tolist([null])
```

Benchmark on multiple server with different benchmark_versions
```
benchmark_versions = tolist(["2.0.2", null])
```

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
`terraform_data.local_exec`. Three different runs with same perftest paramters.

```
terraform_data.local_exec[0] (local-exec): Summary:
terraform_data.local_exec[0] (local-exec): Average publish rate: 220086.6 msgs/s
terraform_data.local_exec[0] (local-exec): Average consume rate: 134183.5 msgs/s
terraform_data.local_exec[0]: Creation complete after 2m3s [id=a59e267f-40cd-d01f-4fd8-e56734f38d39]

terraform_data.local_exec[0] (local-exec): Summary:
terraform_data.local_exec[0] (local-exec): Average publish rate: 533124.4 msgs/s
terraform_data.local_exec[0] (local-exec): Average consume rate: 133995.7 msgs/s
terraform_data.local_exec[0]: Creation complete after 2m2s [id=a76d608d-e4d0-f667-beab-f7904eba0f14]

terraform_data.local_exec[0] (local-exec): Summary:
terraform_data.local_exec[0] (local-exec): Average publish rate: 542616.4 msgs/s
terraform_data.local_exec[0] (local-exec): Average consume rate: 134214.4 msgs/s
terraform_data.local_exec[0]: Creation complete after 2m0s [id=58356ae0-222f-f474-1c21-6dd9a20c1730]
```

First attempts have lower througput, due to servers still running post bootstrap.

## Ongoing work

- Better presentation of the results.
- Any advantages running perftest on a standalone AWS, Azure, GCE server (instead of using another
one create via CloudAMQP)
