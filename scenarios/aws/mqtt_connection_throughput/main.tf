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

  # Install lavinmq (for tooling, then stop)
  install_crystal = true
  lavinmq_version = ""
  install_lavinmq = true
  stop_lavinmq    = true
}

# Install MQTT benchmark tools on all load generators
module "mqtt_tools" {
  count  = var.load_generator_count
  source = "../../../modules/mqtt_tools"

  public_dns         = module.load_generator[count.index].public_dns
  install_mqtt_tools = true

  depends_on = [module.load_generator]
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

  depends_on = [module.mqtt_tools]
}

# Run connection throughput test on each load generator
resource "terraform_data" "mqtt_connection_throughput_tests" {
  count = var.load_generator_count

  connection {
    type    = "ssh"
    user    = "ubuntu"
    host    = module.load_generator[count.index].public_dns
    agent   = true
    timeout = "60m"
  }

  triggers_replace = [
    var.connection_steps,
    var.load_generator_count,
    var.publishers,
    var.consumers,
    var.message_size,
    var.test_duration,
    var.broker_instance_type,
    var.lavinmq_version
  ]

  # Upload test scripts
  provisioner "file" {
    source      = "../../../scripts/mqtt_bench.sh"
    destination = "/home/ubuntu/mqtt_bench.sh"
  }

  provisioner "file" {
    source      = "../../../scripts/run_mqtt_connection_throughput_test.sh"
    destination = "/home/ubuntu/run_mqtt_connection_throughput_test.sh"
  }

  # Execute the connection throughput test
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/mqtt_bench.sh /home/ubuntu/run_mqtt_connection_throughput_test.sh",
      format("/home/ubuntu/run_mqtt_connection_throughput_test.sh %s %s %s %s %s %s %s %s %s",
        module.broker.private_ip,
        var.connection_steps,
        var.load_generator_count,
        count.index,
        var.broker_instance_type,
        var.publishers,
        var.consumers,
        var.message_size,
        var.test_duration
      )
    ]
  }

  depends_on = [terraform_data.broker_fd_limits, terraform_data.loadgen_fd_limits]
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
  value       = "/home/ubuntu/mqtt_connection_throughput_results.md"
}

output "ssh_view_results_command" {
  description = "Command to SSH and view the results"
  value       = format("ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s 'cat /home/ubuntu/mqtt_connection_throughput_results.md'", module.load_generator[0].public_dns)
}

output "scp_download_results_command" {
  description = "Command to download the results file using SCP"
  value       = format("scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s:/home/ubuntu/mqtt_connection_throughput_results.md ./mqtt_connection_throughput_results.md", module.load_generator[0].public_dns)
}
