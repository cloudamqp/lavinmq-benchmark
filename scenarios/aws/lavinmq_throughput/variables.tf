# AWS variables
## AWS region and AZ
variable aws_region {
  type = string
}

variable aws_availability_zone {
  type = string
}

## Tag the AWS resources
variable "tag_created_by" {
  type = string
}

variable tag_name {
  type = string
}

## AMI architecture
variable ami_arch {
  type    = string
  default = "arm64"
}

## Ubuntu code name
variable ubuntu_code_name {
  type    = string
  default = "noble"
}

# Public SSH key path
variable public_ssh_key {
  type = string
}

# SSH key name
variable ssh_key_name {
  type = string
}

# Benchmark servers

variable lavinmq_version {
  type    = string
  default = ""
}

## Broker server
variable broker_instance_type {
  type = string
}

variable broker_name {
  type = string
}

variable "broker_volume_size" {
  description = "Set the root disk volume size"
  type = number
  default = 8
}

## Load generator server
variable load_generator_count {
  type = number
  default = 1
}
variable load_generator_instance_type {
  type = string
}

variable load_generator_name {
  type = string
}

variable "load_generator_volume_size" {
  description = "Set the root disk volume size"
  type = number
  default = 8
}

variable perftest_command {
  type    = string
  default = ""
}
