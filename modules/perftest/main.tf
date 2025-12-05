variable "broker_private_ip" {
  type = string
}

variable "load_generator_public_dns" {
  type = string
}

variable "perftest_command" {
  type    = string
  default = ""
}

variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

resource "terraform_data" "perftest" {
  connection {
    type  = "ssh"
    user  = var.ssh_user
    host  = var.load_generator_public_dns
    agent = true
  }

  triggers_replace = [var.perftest_command]

  provisioner "remote-exec" {
    inline = [
      format("%s %s",
        var.perftest_command,
        format("--uri=amqp://perftest:perftest@%s",
          var.broker_private_ip
        )
      )
    ]
  }
}
