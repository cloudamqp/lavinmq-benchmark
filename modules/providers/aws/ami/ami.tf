variable ami_arch {}
variable ubuntu_code_name {}

// AWS AMI Ubuntu version locator for EC2 instances:
// https://cloud-images.ubuntu.com/locator/ec2/
locals {
  ami_ubuntu_jammy = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-%s-server-*"
  ami_ubuntu_noble = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-%s-server-*"
  ami_ubuntu = var.ubuntu_code_name == "noble" ? local.ami_ubuntu_noble : local.ami_ubuntu_jammy
  ami = format(local.ami_ubuntu, var.ami_arch)
}

data "aws_ami" "ubuntu" {
  # DEBUGGING: pinned to the 2025-06-24 arm64 Ubuntu 24.04 AMI (known-good, kernel predates the suspected ARM64_ERRATUM_4118414 range) instead of most_recent, to isolate whether kernel/AMI drift explains the r7g.large/xlarge stalls
  filter {
    name   = "image-id"
    values = ["ami-0c7114fa3eac14de1"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

output "ami_id" {
  value = data.aws_ami.ubuntu.id
}
