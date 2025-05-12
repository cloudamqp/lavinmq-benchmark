variable ami_arch {}
variable ubuntu_code_name {}

// AWS AMI Ubuntu version locator for EC2 instances:
// https://cloud-images.ubuntu.com/locator/ec2/
locals {
  ami_ubuntu_jammy = "ubuntu/images/hvm:ebs-ssd/ubuntu-jammy-22.04-%s-server-*"
  ami_ubuntu_noble = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-%s-server-*"
  ami_ubuntu = var.ubuntu_code_name == "noble" ? local.ami_ubuntu_noble : local.ami_ubuntu_jammy
  ami = format(local.ami_ubuntu, var.ami_arch)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [local.ami]
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
