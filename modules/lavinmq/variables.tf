variable "public_dns" {
  type = string
}

variable "install_crystal" {
  type    = bool
  default = false
}

variable "install_lavinmq" {
  type    = bool
  default = false
}

variable "create_lavinmq_user" {
  type    = bool
  default = false
}

variable "lavinmq_version" {
  type    = string
  default = ""
}

variable "stop_lavinmq" {
  type    = bool
  default = false
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "os_type" {
  type    = string
  default = "ubuntu"
}
