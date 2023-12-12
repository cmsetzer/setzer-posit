terraform {
  required_version = "~> 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Project = "Posit Take-Home Assignment"
    }
  }
}


# VPC

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 1)
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "security_group" {
  name   = "allow-ssh-security-group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.ec2_instance.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route_table.id
}


# EC2

data "local_file" "user_data" {
  filename = "${path.module}/user_data.sh"
}

resource "aws_instance" "ec2_instance" {
  instance_type = "t2.micro"

  # Amazon Linux 2023
  ami = "ami-093467ec28ae4fe03"

  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.security_group.id]

  user_data_replace_on_change = true
  user_data                   = data.local_file.user_data.content

  tags = {
    Name = "Posit Take-Home Assignment Instance"
  }
}
