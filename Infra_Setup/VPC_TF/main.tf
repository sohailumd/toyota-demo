locals {
  name   = "T-NW-FW"
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${local.name}-vpc"
    owner = "terraform"
  }
}

resource "aws_subnet" "public-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${local.name}-public-sn"
    owner = "terraform"
  }
}

resource "aws_subnet" "private-sn" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "${local.name}-private-sn"
    owner = "terraform"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name}-IGW"
    owner = "terraform"
  }
}

resource "aws_eip" "eip_nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public-sn.id

  tags = {
    Name = "${local.name}-NAT-GW"
    owner = "terraform"
  }

}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${local.name}-private-rt"
    owner = "terraform"
  }

  depends_on = [ aws_nat_gateway.nat_gateway ]
}

resource "aws_route_table_association" "private-sn-association" {
  subnet_id      = aws_subnet.private-sn.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${local.name}-public-rt"
    owner = "terraform"
  }
}

resource "aws_route_table_association" "public-sn-association" {
  subnet_id      = aws_subnet.public-sn.id
  route_table_id = aws_route_table.public-rt.id
}