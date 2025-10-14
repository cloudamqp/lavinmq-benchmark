variable aws_availability_zone {}
variable tag_created_by {}
variable tag_name {}

resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = var.aws_availability_zone
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

output "subnet_identifier" {
  value = aws_subnet.subnet.id
}

resource "aws_route_table_association" "rt-a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_vpc_security_group_ingress_rule" "ssh_traffic" {
  security_group_id = aws_vpc.vpc.default_security_group_id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

resource "aws_vpc_security_group_ingress_rule" "lavinmq_management" {
  security_group_id = aws_vpc.vpc.default_security_group_id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 15672
  to_port     = 15672

  tags = {
    Name      = var.tag_name
    CreatedBy = var.tag_created_by
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
