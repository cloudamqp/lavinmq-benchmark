resource "aws_instance" "benchmark" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.benchmark.instance_type
  subnet_id     = aws_subnet.subnet.id
  key_name      = aws_key_pair.ssh-key.key_name

  user_data = local.bootstrap

  tags = {
    Name      = local.benchmark.name
    CreatedBy = local.created_by
  }
}

resource "aws_eip" "benchmark_eip" {
  domain = "vpc"

  instance                  = aws_instance.benchmark.id
  associate_with_private_ip = aws_instance.benchmark.private_ip

  tags = {
    Name      = local.benchmark.name
    CreatedBy = local.created_by
  }

  depends_on = [aws_internet_gateway.gw]
}