locals {
  name   = "toyota-demo"
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/20"
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-vpc"
    resource = "toyota-demo"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.name}-demo-rt"
    resource = "toyota-demo"
  }
}

resource "aws_subnet" "service-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${local.name}-service-sn"
    resource = "toyota-demo"
  }
}

resource "aws_route_table_association" "service-sn-association" {
  subnet_id      = aws_subnet.service-sn.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_subnet" "database-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${local.name}-database-sn"
    resource = "toyota-demo"
  }
}

resource "aws_route_table_association" "database-sn-association" {
  subnet_id      = aws_subnet.database-sn.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_subnet" "app-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "${local.name}-app-sn"
    resource = "toyota-demo"
  }
}

resource "aws_route_table_association" "app-sn-association" {
  subnet_id      = aws_subnet.app-sn.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-internet-gw"
    resource = "toyota-demo"
  }
}
