resource "aws_key_pair" "ssh-key" {
  key_name   = "terraform-benchmark"
  public_key = file("~/.ssh/id_ed25519.pub")
}
