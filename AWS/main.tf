provider "aws" {
  region = var.aws_region
}

# create servers
module "broker" {
  source = "./instance"

  instance_type     = var.broker_instance_type
  instance_name     = var.broker_name
  ami_arch          = var.ami_arch
  lavinmq_version   = var.lavinmq_version
  tag_created_by    = var.tag_created_by
  subnet_id         = aws_subnet.subnet.id
  ssh_key_pair_name = aws_key_pair.ssh_key.key_name
}

module "load_generator" {
  source = "./instance"

  instance_type     = var.load_generator_instance_type
  instance_name     = var.load_generator_name
  ami_arch          = var.ami_arch
  lavinmq_version   = var.lavinmq_version
  tag_created_by    = var.tag_created_by
  subnet_id         = aws_subnet.subnet.id
  ssh_key_pair_name = aws_key_pair.ssh_key.key_name
}
