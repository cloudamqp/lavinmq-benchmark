variable ami_arch {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [
      format("ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-%s-server-*",
      var.ami_arch)
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
