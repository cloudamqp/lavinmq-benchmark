resource "terraform_data" "ensure_lavinmq" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.broker.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "scripts/ensure_lavinmq.sh"
    destination = "/tmp/ensure_lavinmq.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ensure_lavinmq.sh",
      "/tmp/ensure_lavinmq.sh",
    ]
  }
}

resource "terraform_data" "ensure_lavinmqperf" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.load_generator.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "scripts/ensure_lavinmqperf.sh"
    destination = "/tmp/ensure_lavinmqperf.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ensure_lavinmqperf.sh",
      "/tmp/ensure_lavinmqperf.sh",
    ]
  }

  depends_on = [terraform_data.ensure_lavinmq]
}

resource "terraform_data" "perftest" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = module.load_generator.public_dns
    agent = true
  }

  triggers_replace = [var.perftest_command]

  provisioner "remote-exec" {
    inline = [
      format("%s %s",
        var.perftest_command,
        format("--uri=amqp://perftest:perftest@%s",
          module.broker.private_ip
        )
      )
    ]
  }

  depends_on = [terraform_data.ensure_lavinmqperf]
}
