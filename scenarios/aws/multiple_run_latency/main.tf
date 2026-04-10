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
  source = "../../../modules/providers/aws/load_generator"

  # Create AWS instance
  ami_id         = module.ami.ami_id
  instance_type  = var.load_generator_instance_type
  ssh_key_name   = var.ssh_key_name
  subnet_id      = module.network.subnet_identifier
  tag_name       = var.load_generator_name
  tag_created_by = var.tag_created_by
  volume_size    = var.load_generator_volume_size

  # Install lavinmq
  install_crystal = true
  lavinmq_version = "" // Use latest version
  install_lavinmq = true
  stop_lavinmq    = true
}

# Custom resource to run multiple latency tests
resource "terraform_data" "multiple_latency_tests" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.load_generator.public_dns
    agent = true
  }

  # Trigger replacement when message sizes, rate limits, test duration, broker instance type, lavinmq version, or num_runs changes
  triggers_replace = [
    join(",", var.message_sizes),
    join(",", var.rate_limits),
    var.test_duration,
    var.broker_instance_type,
    var.lavinmq_version,
    var.num_runs
  ]

  # Upload the test script
  provisioner "file" {
    source      = "../../../scripts/run_multiple_latency_tests.sh"
    destination = "/home/ubuntu/run_multiple_latency_tests.sh"
  }

  # Execute the multiple test runs
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/run_multiple_latency_tests.sh",
      format("/home/ubuntu/run_multiple_latency_tests.sh %s %s %s %s %s %s",
        module.broker.private_ip,
        join(",", var.message_sizes),
        join(",", var.rate_limits),
        var.test_duration,
        var.broker_instance_type,
        var.num_runs
      )
    ]
  }

  depends_on = [module.broker.user_ids]
}

# Outputs
output "broker_public_dns" {
  description = "Public DNS name of the broker instance"
  value       = module.broker.public_dns
}

output "load_generator_public_dns" {
  description = "Public DNS name of the load generator instance"
  value       = module.load_generator.public_dns
}

output "results_file_path" {
  description = "Path to the results file on the load generator instance"
  value       = "/home/ubuntu/latency_results.md"
}

output "ssh_view_results_command" {
  description = "Command to SSH and view the results"
  value       = format("ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s 'cat /home/ubuntu/latency_results.md'", module.load_generator.public_dns)
}

output "scp_download_results_command" {
  description = "Command to download the results file using SCP"
  value       = format("scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s:/home/ubuntu/latency_results.md ./latency_results.md", module.load_generator.public_dns)
}
