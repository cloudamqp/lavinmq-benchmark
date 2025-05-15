# AWS input paramters
variable ami_id {
  type = string
}

variable instance_type {
  type = string
}

variable "tag_created_by" {
  type = string
}

variable tag_name {
  type = string
}

variable ssh_key_name {
  type = string
}

variable subnet_id {
  type = string
}

variable "volume_size" {
  description = "Set the root disk volume size"
  type = number
  default = 8
}

# Install software paramter
variable install_crystal {
  type    = bool
  default = false
}

variable lavinmq_version {
  type    = string
  default = ""
}

variable install_lavinmq {
  type    = bool
  default = false
}

variable "create_lavinmq_user" {
  type    = bool
  default = false
}

variable stop_lavinmq {
  type    = bool
  default = false
}
