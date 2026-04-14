# AWS variables
## AWS region and AZ
variable "aws_region" {
  type = string
}

variable "aws_availability_zone" {
  type = string
}

## Tag the AWS resources
variable "tag_created_by" {
  type = string
}

variable "tag_name" {
  type = string
}

## AMI architecture
variable "ami_arch" {
  type    = string
  default = "arm64"
}

## Ubuntu code name
variable "ubuntu_code_name" {
  type    = string
  default = "noble"
}

# Public SSH key path
variable "public_ssh_key" {
  type = string
}

# SSH key name
variable "ssh_key_name" {
  type = string
}

# Benchmark servers

variable "lavinmq_version" {
  type    = string
  default = ""
}

## Broker server
variable "broker_instance_type" {
  type = string
}

variable "broker_name" {
  type = string
}

variable "broker_volume_size" {
  description = "Set the root disk volume size"
  type        = number
  default     = 8
}

## Load generator servers
variable "load_generator_count" {
  description = "Number of load generator instances"
  type        = number
  default     = 10
}

variable "load_generator_instance_type" {
  type = string
}

variable "load_generator_name" {
  type = string
}

variable "load_generator_volume_size" {
  description = "Set the root disk volume size"
  type        = number
  default     = 8
}

variable "secondary_private_ip_count" {
  description = "Number of secondary private IPs per load generator (each adds ~60k connection capacity)"
  type        = number
  default     = 2
}

# Connection throughput test parameters
variable "connection_steps" {
  description = "Comma-separated background connection counts to test"
  type        = string
  default     = "100,10000,100000,500000,1000000"
}

variable "publishers" {
  description = "Number of active publishers during throughput test"
  type        = number
  default     = 1
}

variable "consumers" {
  description = "Number of active consumers during throughput test"
  type        = number
  default     = 1
}

variable "message_size" {
  description = "Message size in bytes for throughput test"
  type        = number
  default     = 256
}

variable "test_duration" {
  description = "Duration of each throughput test in seconds"
  type        = number
  default     = 60
}
