provider "aws" {
  region = var.aws_region
}

# # create network
# module "network" {
#   source = "./network"

#   availability_zone = var.aws_availability_zone
#   tag_created_by    = var.tag_created_by
#   tag_name          = var.tag_name
# }

# create servers
module "benchmark" {
  source = "./instance"

  instance_type     = var.benchmark_instance_type
  instance_name     = var.benchmark_name
  ami_arch          = var.ami_arch
  tag_created_by    = var.tag_created_by
  subnet_id         = aws_subnet.subnet.id
  ssh_key_pair_name = aws_key_pair.ssh_key.key_name
}

module "perftest" {
  source = "./instance"

  instance_type     = var.perftest_instance_type
  instance_name     = var.perftest_name
  ami_arch          = var.ami_arch
  tag_created_by    = var.tag_created_by
  subnet_id         = aws_subnet.subnet.id
  ssh_key_pair_name = aws_key_pair.ssh_key.key_name
}
