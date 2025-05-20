# AWS servers

Modules designed to provision AWS resources required for running benchmarks.

## Variables

Templates are provided to either create `terraform.tfvars` file or `.env` and can be found
within the `variable_template` folder. One of them are required to be able to run the benchmark with
AWS resources.

## Modules

Terraform modules for provisioning resources and data sources to set up the infrastructure. Both the
broker and load generator servers are deployed within the same VPC to enable internal communication.

### AMI

This module retrieves the Amazon Machine Image (AMI) used to create EC2 instances. It supports
customization of the server architecture and Ubuntu version.

### Broker

This module provisions and configures the broker server, including the installation of LavinMQ on an
EC2 instance.

### Instance

This module handles the creation of an EC2 instance in AWS, using the specified AMI and network
configuration.

### Load Generator

This module sets up and configures the load generator server to simulate traffic for benchmarking
purposes.

### Network

This module establishes the networking infrastructure, including subnets, security groups, and the
VPC, for the broker and load generator servers.

### SSH

This module generates an SSH key pair and uploads it to the EC2 instances during provisioning.
The key pair enables secure access to the instances via SSH.
