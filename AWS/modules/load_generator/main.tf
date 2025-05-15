module "instance" {
  source = "../../modules/instance"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  ssh_key_pair_name = var.ssh_key_name
  subnet_id         = var.subnet_id
  tag_created_by    = var.tag_created_by
  tag_name          = var.tag_name
  volume_size       = var.volume_size
}

module "install_lavinmq" {
  source = "../../modules/lavinmq"

  public_dns          = module.instance.public_dns
  install_crystal     = var.install_crystal
  lavinmq_version     = var.lavinmq_version
  install_lavinmq     = var.install_lavinmq
  create_lavinmq_user = var.create_lavinmq_user
  stop_lavinmq        = var.stop_lavinmq
}

output "public_dns" {
  value = module.instance.public_dns
}

output "private_ip" {
  value = module.instance.private_ip
}
