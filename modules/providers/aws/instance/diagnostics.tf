resource "terraform_data" "diagnostics" {
  connection {
    type  = "ssh"
    user  = "ubuntu"
    host  = aws_instance.instance.public_dns
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo '=== Instance Diagnostics ==='",
      "uname -a",
      "cat /proc/version",
      "TOKEN=$(curl -s -X PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')",
      "AMI_ID=$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" http://169.254.169.254/latest/meta-data/ami-id)",
      "echo \"AMI ID: $AMI_ID\"",
      "INSTANCE_ID=$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" http://169.254.169.254/latest/meta-data/instance-id)",
      "echo \"Instance ID: $INSTANCE_ID\"",
      "INSTANCE_TYPE=$(curl -s -H \"X-aws-ec2-metadata-token: $TOKEN\" http://169.254.169.254/latest/meta-data/instance-type)",
      "echo \"Instance Type: $INSTANCE_TYPE\"",
      "echo '============================'"
    ]
  }

  depends_on = [aws_instance.instance]
}
