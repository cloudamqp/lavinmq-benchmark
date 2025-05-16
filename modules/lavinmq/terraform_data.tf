resource "terraform_data" "install_crystal" {
  count = var.install_crystal == false ? 0 : 1

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = var.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "../../../scripts/install_crystal.sh"
    destination = "/tmp/install_crystal.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_crystal.sh",
      "sudo /tmp/install_crystal.sh",
    ]
  }
}

resource "terraform_data" "install_lavinmq" {
  count = var.install_lavinmq == false ? 0 : 1

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = var.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "../../../scripts/install_lavinmq.sh"
    destination = "/tmp/install_lavinmq.sh"
  }

  triggers_replace = [var.lavinmq_version]

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_lavinmq.sh",
      "sudo LAVINMQ_VERSION=${var.lavinmq_version} /tmp/install_lavinmq.sh",
    ]
  }

  depends_on = [ terraform_data.install_crystal ]
}

resource "terraform_data" "create_user" {
  count = var.create_lavinmq_user == false ? 0 : 1

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = var.public_dns
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo lavinmqctl add_user perftest perftest",
      "sudo lavinmqctl set_user_tags perftest administrator",
      "sudo lavinmqctl set_permissions perftest '.*' '.*' '.*'"
    ]
  }

  depends_on = [ terraform_data.install_lavinmq ]
}

output "user_ids" {
  value = [for user in terraform_data.create_user : user.id]
}

resource "terraform_data" "stop_lavinmq" {
  count = var.stop_lavinmq == false ? 0 : 1

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = var.public_dns
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop lavinmq.service"
    ]
  }

  depends_on = [ terraform_data.install_lavinmq ]
}
