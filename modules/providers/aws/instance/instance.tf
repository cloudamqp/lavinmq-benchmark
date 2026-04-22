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

output "public_dns" {
  value = aws_instance.instance.public_dns
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}
