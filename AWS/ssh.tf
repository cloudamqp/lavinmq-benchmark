resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-benchmark"
  public_key = file(var.public_ssh_key)
}
