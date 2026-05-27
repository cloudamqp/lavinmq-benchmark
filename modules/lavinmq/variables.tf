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

variable "configure_lavinmq" {
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

variable "source_repo" {
  description = "Git repository URL to clone and build from (e.g. https://github.com/cloudamqp/lavinmq). Empty = use apt-installed binary."
  type        = string
  default     = ""
}

variable "source_ref" {
  description = "Git ref (branch or commit hash) to check out when building from source."
  type        = string
  default     = ""
}

variable "build_target" {
  description = "Which binary to build: 'broker' or 'perf'."
  type        = string
  default     = ""
}
