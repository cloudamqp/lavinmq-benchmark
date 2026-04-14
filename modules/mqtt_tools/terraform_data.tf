resource "terraform_data" "install_mqtt_tools" {
  count = var.install_mqtt_tools == false ? 0 : 1

  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = var.public_dns
    agent = true
  }

  provisioner "file" {
    source      = "../../../scripts/install_mqtt_tools.sh"
    destination = "/tmp/install_mqtt_tools.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_mqtt_tools.sh",
      "sudo /tmp/install_mqtt_tools.sh",
    ]
  }
}
