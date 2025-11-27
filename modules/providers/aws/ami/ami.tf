variable "ami_arch" {}
variable "ubuntu_code_name" {}
variable "os_type" {
  type    = string
  default = "ubuntu"
  validation {
    condition     = contains(["ubuntu", "freebsd"], var.os_type)
    error_message = "os_type must be either 'ubuntu' or 'freebsd'"
  }
}
variable "freebsd_version" {
  type    = string
  default = "14.2"
}

// AWS AMI Ubuntu version locator for EC2 instances:
// https://cloud-images.ubuntu.com/locator/ec2/
locals {
  ami_ubuntu_jammy = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-%s-server-*"
  ami_ubuntu_noble = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-%s-server-*"
  ami_ubuntu       = var.ubuntu_code_name == "noble" ? local.ami_ubuntu_noble : local.ami_ubuntu_jammy
  ami_ubuntu_name  = format(local.ami_ubuntu, var.ami_arch)

  // FreeBSD AMI naming pattern
  // FreeBSD uses amd64/arm64 in AMI names, with space after arch
  freebsd_arch     = var.ami_arch == "arm64" ? "arm64" : "amd64"
  ami_freebsd_name = "FreeBSD ${var.freebsd_version}-RELEASE-${local.freebsd_arch} *"
}

data "aws_ami" "ubuntu" {
  count       = var.os_type == "ubuntu" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = [local.ami_ubuntu_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "freebsd" {
  count       = var.os_type == "freebsd" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = [local.ami_freebsd_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  // FreeBSD Foundation AWS account
  owners = ["782442783595"]
}

output "ami_id" {
  value = var.os_type == "ubuntu" ? data.aws_ami.ubuntu[0].id : data.aws_ami.freebsd[0].id
}

output "ssh_user" {
  value = var.os_type == "ubuntu" ? "ubuntu" : "ec2-user"
}

output "os_type" {
  value = var.os_type
}
