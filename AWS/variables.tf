# AWS region
variable aws_region {
  type = string
}

variable aws_availability_zone {
  type = string
}

# AWS resource tags
variable "tag_created_by" {
  type = string
}

variable tag_name {
  type = string
}

# AMI architecture
variable ami_arch {
  type = string
}

# Public SSH key path
variable public_ssh_key {
  type = string
}

# SSH key name
variable ssh_key_name {
  type = string
}

variable lavinmq_version {
  type = string
  default = ""
}

# Benchmark server
variable benchmark_instance_type {
  type = string
}

variable benchmark_name {
  type = string
}

# Perftest server
variable perftest_instance_type {
  type = string
}

variable perftest_name {
  type = string
}

variable perftest_command {
  type    = string
  default = ""
}
