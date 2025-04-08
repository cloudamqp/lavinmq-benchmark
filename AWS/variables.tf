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

# Benchmark servers
# Broker server
variable broker_instance_type {
  type = string
}

variable broker_name {
  type = string
}

# Load generator server
variable load_generator_instance_type {
  type = string
}

variable load_generator_name {
  type = string
}

variable perftest_command {
  type    = string
  default = ""
}
