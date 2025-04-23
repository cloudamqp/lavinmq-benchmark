variable public_ssh_key {}
variable ssh_key_name {}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key_name
  public_key = file(var.public_ssh_key)
}
