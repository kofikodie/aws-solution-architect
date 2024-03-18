terraform {
  cloud {
    organization = "dragon-ws"

    workspaces {
      name = "saa-c03"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-1b"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.16.0/20"

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.32.0/20"

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "web" {
  ami             = "ami-0766b4b472db7e3b9"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_a.id
  security_groups = [aws_security_group.ssh.id, aws_security_group.outbound.id]

  tags = {
    Name = "web"
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound" {
  name        = "outbound"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
