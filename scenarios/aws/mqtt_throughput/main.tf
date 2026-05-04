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

  # Install lavinmq (for lavinmqperf, not used here but keeps instance consistent) # TODO
  install_crystal = true
  lavinmq_version = ""
  install_lavinmq = true
  stop_lavinmq    = true
}

# Install MQTT benchmark tools on load generator
module "mqtt_tools" {
  source = "../../../modules/mqtt_tools"

  public_dns         = module.load_generator.public_dns
  install_mqtt_tools = true

  depends_on = [module.load_generator]
}

# Run multiple MQTT throughput tests
resource "terraform_data" "mqtt_throughput_tests" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.load_generator.public_dns
    agent = true
  }

  # Trigger replacement when test parameters change
  triggers_replace = [
    join(",", var.message_sizes),
    var.test_duration,
    var.broker_instance_type,
    var.lavinmq_version,
    var.num_runs
  ]

  # Upload test scripts
  provisioner "file" {
    source      = "../../../scripts/mqtt_bench.sh"
    destination = "/home/ubuntu/mqtt_bench.sh"
  }

  provisioner "file" {
    source      = "../../../scripts/run_mqtt_throughput_tests.sh"
    destination = "/home/ubuntu/run_mqtt_throughput_tests.sh"
  }

  # Execute the multiple test runs
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/mqtt_bench.sh /home/ubuntu/run_mqtt_throughput_tests.sh",
      format("/home/ubuntu/run_mqtt_throughput_tests.sh %s %s %s %s %s",
        module.broker.private_ip,
        join(",", var.message_sizes),
        var.test_duration,
        var.broker_instance_type,
        var.num_runs
      )
    ]
  }

  depends_on = [module.broker.user_ids, module.mqtt_tools]
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
  description = "Path to the results CSV file on the load generator instance"
  value       = "/home/ubuntu/mqtt_throughput_results.csv"
}

output "results_config_path" {
  description = "Path to the results JSON config file on the load generator instance"
  value       = "/home/ubuntu/mqtt_throughput_results.json"
}

output "ssh_view_results_command" {
  description = "Command to SSH and view the results"
  value       = format("ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s 'cat /home/ubuntu/mqtt_throughput_results.csv'", module.load_generator.public_dns)
}

output "scp_download_results_command" {
  description = "Commands to download the results files using SCP"
  value       = format("scp -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=/tmp/known-hosts ubuntu@%s:'/home/ubuntu/mqtt_throughput_results.csv /home/ubuntu/mqtt_throughput_results.json' .", module.load_generator.public_dns)
}
