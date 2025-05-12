provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  aws_availability_zone = var.aws_availability_zone
  tag_created_by        = var.tag_created_by
  tag_name              = var.tag_name
}

module "ssh" {
  source = "../../modules/ssh"

  ssh_key_name   = var.ssh_key_name
  public_ssh_key = var.public_ssh_key
}


module "ami" {
  source = "../../modules/ami"

  ami_arch         = var.ami_arch
  ubuntu_code_name = var.ubuntu_code_name
}

module "broker" {
  source = "../../modules/instance"

  instance_type     = var.broker_instance_type
  instance_name     = var.broker_name
  lavinmq_version   = var.lavinmq_version
  tag_created_by    = var.tag_created_by

  subnet_id         = module.network.subnet_identifier

  ami_id            = module.ami.ami_id
  volume_size       = var.broker_volume_size
  
  ssh_key_pair_name = var.ssh_key_name
}

module "load_generator" {
  count = var.load_generator_count
  source = "../../modules/instance"

  instance_type     = var.load_generator_instance_type
  instance_name     = format("%s_%s", var.load_generator_name, count.index)
  lavinmq_version   = var.lavinmq_version
  tag_created_by    = var.tag_created_by
  subnet_id         = module.network.subnet_identifier

  ami_id            = module.ami.ami_id
  volume_size       = var.load_generator_volume_size
  
  ssh_key_pair_name = var.ssh_key_name
}

module "remote_execute" {
  count = var.load_generator_count
  source = "../../modules/remote_execute" 

  broker_public_dns         = module.broker.public_dns
  broker_private_ip         = module.broker.private_ip
  load_generator_public_dns = module.load_generator[count.index].public_dns
  perftest_command          = var.perftest_command
}
