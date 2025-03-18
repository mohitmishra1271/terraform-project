provider "aws" {
region = "eu-south-1"
}

resource "aws_instance" "one" {
  ami             = "ami-023a307f3d27ea427"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  vpc_security_group_ids = [aws_security_group.three.id]
  availability_zone = "ap-south-1a"
  user_data       = <<EOF
#!/bin/bash
sudo -i
apt install apache2 -y
systemctl start apache2
chkconfig apache2 on
echo "hai all this is my app created by terraform infrastructurte by Mohit on server-1" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "two" {
  ami             = "ami-05c179eced2eb9b5b"
  instance_type   = "t2.micro"
  key_name        = "newkey"
  vpc_security_group_ids = [aws_security_group.three.id]
  availability_zone = "ap-south-1b"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "hai all this is my website created by terraform infrastructurte by Mohit on server-2" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-server-2"
  }
}

resource "aws_security_group" "three" {
  name = "elb-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "four" {
  bucket = "mohitdemoterraform-integration-101"
}

resource "aws_iam_user" "five" {
for_each = var.user_names
name = each.value
}

variable "user_names" {
description = "*"
type = set(string)
default = ["mohit", "rohit"]
}

resource "aws_ebs_volume" "six" {
 availability_zone = "ap-south-1a"
  size = 10
  tags = {
    Name = "terraform1-001"
}
}
