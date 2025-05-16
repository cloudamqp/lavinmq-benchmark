# input parameters of the module
variable "ami_id" {}
variable "instance_type" {}
variable "ssh_key_pair_name" {}
variable "subnet_id" {}
variable "tag_created_by" {}
variable "tag_name" {}
variable "volume_size" {}

resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.ssh_key_pair_name

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

resource "aws_eip" "this" {
  domain = "vpc"

  instance                  = aws_instance.instance.id
  associate_with_private_ip = aws_instance.instance.private_ip

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

output "public_dns" {
  value = aws_eip.this.public_dns
}

output "private_ip" {
  value = aws_eip.this.private_ip
}
