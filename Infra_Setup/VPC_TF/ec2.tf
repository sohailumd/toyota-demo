data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical

}

resource "aws_instance" "client" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg-01.id]
#  user_data              = "${file("userdata_web.sh")}"
  subnet_id              = aws_subnet.public-sn.id
    associate_public_ip_address = true

  tags = {
    Name = "${local.name}-client-vm"
    owner = "terraform"
  }
}

resource "aws_instance" "server" {
#  ami                    = "ami-0f5daaa3a7fb3378b"
    ami = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg-01.id]
  subnet_id              = aws_subnet.private-sn.id

  tags = {
    Name = "${local.name}-server-vm"
    owner = "terraform"
  }
}

#Security Group Resource to open port 80 
resource "aws_security_group" "web-sg-01" {
  name        = "Web-SG-01"
  description = "Web-SG-01"
  vpc_id      = aws_vpc.main.id

  dynamic ingress {
    for_each = var.port

    content {
    description      = "from Everywhere"
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-public-sn"
    owner = "terraform"
  }
  
}

output "public_ip" {
  value = aws_instance.client.public_ip
}

output "private_ip" {
  value = aws_instance.server.public_ip
}