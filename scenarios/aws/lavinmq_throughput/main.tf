terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../../modules/providers/aws/network"

  aws_availability_zone = var.aws_availability_zone
  tag_created_by        = var.tag_created_by
  tag_name              = var.tag_name
}

module "ssh" {
  source = "../../../modules/providers/aws/ssh"

  ssh_key_name   = var.ssh_key_name
  public_ssh_key = var.public_ssh_key
}


module "ami" {
  source = "../../../modules/providers/aws/ami"

  ami_arch         = var.ami_arch
  ubuntu_code_name = var.ubuntu_code_name
}

module "broker" {
  source = "../../../modules/providers/aws/broker"

  # Create AWS instance
  ami_id              = module.ami.ami_id
  instance_type       = var.broker_instance_type
  ssh_key_name        = var.ssh_key_name
  subnet_id           = module.network.subnet_identifier
  tag_created_by      = var.tag_created_by
  tag_name            = var.broker_name
  volume_size         = var.broker_volume_size

  # Install lavinmq
  install_crystal     = true
  lavinmq_version     = var.lavinmq_version
  install_lavinmq     = true
  create_lavinmq_user = true
}

module "load_generator" {
  count = var.load_generator_count
  source = "../../../modules/providers/aws/load_generator"

  # Create AWS instance
  ami_id            = module.ami.ami_id
  instance_type     = var.load_generator_instance_type
  ssh_key_name      = var.ssh_key_name
  subnet_id         = module.network.subnet_identifier
  tag_name          = format("%s_%s", var.load_generator_name, count.index)
  tag_created_by    = var.tag_created_by
  volume_size       = var.load_generator_volume_size
  
  # Install lavinmq
  install_crystal = true
  lavinmq_version = var.lavinmq_version
  install_lavinmq = true
  stop_lavinmq    = true
}

module "performance_test" {
  count = var.load_generator_count
  source = "../../../modules/perftest"

  broker_private_ip         = module.broker.private_ip
  load_generator_public_dns = module.load_generator[count.index].public_dns
  perftest_command          = var.perftest_command

  depends_on = [module.broker.user_ids]
}
