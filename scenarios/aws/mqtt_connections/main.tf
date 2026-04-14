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
  ami_id         = module.ami.ami_id
  instance_type  = var.broker_instance_type
  ssh_key_name   = var.ssh_key_name
  subnet_id      = module.network.subnet_identifier
  tag_created_by = var.tag_created_by
  tag_name       = var.broker_name
  volume_size    = var.broker_volume_size

  # Install lavinmq
  install_crystal     = true
  lavinmq_version     = var.lavinmq_version
  install_lavinmq     = true
  configure_lavinmq   = true
  create_lavinmq_user = true
}

module "load_generator" {
  count  = var.load_generator_count
  source = "../../../modules/providers/aws/load_generator"

  # Create AWS instance
  ami_id         = module.ami.ami_id
  instance_type  = var.load_generator_instance_type
  ssh_key_name   = var.ssh_key_name
  subnet_id      = module.network.subnet_identifier
  tag_name       = format("%s_%s", var.load_generator_name, count.index)
  tag_created_by = var.tag_created_by
  volume_size                = var.load_generator_volume_size
  secondary_private_ip_count = var.secondary_private_ip_count

}

# Raise FD limits on broker
resource "terraform_data" "broker_fd_limits" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.broker.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "../../../scripts/raise_fd_limits.sh"
    destination = "/tmp/raise_fd_limits.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/raise_fd_limits.sh",
      "sudo /tmp/raise_fd_limits.sh",
      "sudo systemctl restart lavinmq.service"
    ]
  }

  depends_on = [module.broker.user_ids]
}

# Raise FD limits on all load generators
resource "terraform_data" "loadgen_fd_limits" {
  count = var.load_generator_count

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.load_generator[count.index].public_dns
    agent = true
  }

  provisioner "file" {
    source      = "../../../scripts/raise_fd_limits.sh"
    destination = "/tmp/raise_fd_limits.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/raise_fd_limits.sh",
      "sudo /tmp/raise_fd_limits.sh",
    ]
  }

  depends_on = [module.load_generator]
}

# Prepare load generators: install Go and build connection tool
resource "terraform_data" "prepare_load_generators" {
  count = var.load_generator_count

  connection {
    type    = "ssh"
    user    = "ubuntu"
    host    = module.load_generator[count.index].public_dns
    agent   = true
    timeout = "10m"
  }

  provisioner "file" {
    source      = "../../../scripts/mqtt_connect.go"
    destination = "/home/ubuntu/mqtt_connect.go"
  }

  provisioner "remote-exec" {
    inline = [
      "which go > /dev/null 2>&1 || (sudo apt-get update -qq > /dev/null && sudo apt-get install -y -qq golang-go > /dev/null)",
      "cd /home/ubuntu && go build -o mqtt_connect mqtt_connect.go"
    ]
  }

  depends_on = [terraform_data.loadgen_fd_limits]
}

# Outputs
output "broker_public_dns" {
  description = "Public DNS name of the broker instance"
  value       = module.broker.public_dns
}

output "load_generator_public_dns" {
  description = "Public DNS names of the load generator instances"
  value       = [for lg in module.load_generator : lg.public_dns]
}

output "results_file_path" {
  description = "Path to the results file on load generator 0"
  value       = "/home/ubuntu/mqtt_connection_results.md"
}

output "ssh_view_results_command" {
  description = "Command to SSH and view the results"
  value       = format("ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s 'cat /home/ubuntu/mqtt_connection_results.md'", module.load_generator[0].public_dns)
}

output "broker_private_ip" {
  description = "Private IP of the broker instance"
  value       = module.broker.private_ip
}

output "run_test_command" {
  description = "Command to run the interactive connection test"
  value       = format("terraform output -json load_generator_public_dns | python3 -c \"import sys,json; [print(x) for x in json.load(sys.stdin)]\" > /tmp/workers.txt && ../../../scripts/run_connection_test_interactive.sh %s /tmp/workers.txt %s", module.broker.public_dns, module.broker.private_ip)
}
