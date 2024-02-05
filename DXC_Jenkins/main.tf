#EC2 instance using UserData
provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "demo-instance" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.JenkinsSG.id]
  user_data              = "${file("userdata.sh")}"
  root_block_device {
    volume_size = "30"
  }
  tags = {
    Name     = "Jenkins01"
    resource = "toyota-demo"
  }
}

#Security Group Resource to open port 80 
resource "aws_security_group" "JenkinsSG" {
  name        = "Jenkins-SG"
  description = "Jenkins-SG"

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
    resource = "toyota-demo"
  }
}

output "public_ip" {
  value = aws_instance.demo-instance.public_ip
}