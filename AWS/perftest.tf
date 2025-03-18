resource "aws_instance" "perftest" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.perftest.instance_type
  subnet_id     = aws_subnet.subnet.id
  key_name      = aws_key_pair.ssh-key.key_name

  user_data = local.bootstrap

  tags = {
    Name      = local.perftest.name
    CreatedBy = local.created_by
  }
}

resource "aws_eip" "perftest_eip" {
  domain = "vpc"

  instance                  = aws_instance.perftest.id
  associate_with_private_ip = aws_instance.perftest.private_ip

  tags = {
    Name      = local.perftest.name
    CreatedBy = local.created_by
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "terraform_data" "ensure_lavinmqperf" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = aws_eip.perftest_eip.public_dns
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
}

resource "terraform_data" "perftest" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = aws_eip.perftest_eip.public_dns
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      format("%s %s",
        local.perftest.command,
        format("--uri=amqp://perftest:perftest@%s",
          aws_instance.benchmark.private_ip
        )
      )
    ]
  }

  depends_on = [terraform_data.ensure_lavinmqperf]
}