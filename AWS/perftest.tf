resource "aws_instance" "perftest" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.perftest.instance_type
  subnet_id     = aws_subnet.subnet.id
  key_name      = aws_key_pair.ssh-key.key_name

  user_data = file("scripts/bootstrap.sh")

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
