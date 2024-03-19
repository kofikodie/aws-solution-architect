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

locals {
  user_data = <<-EOF
                #!/bin/bash
                # Use this for your user data (script from top to bottom)
                # install httpd (Linux 2 version)
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
                EOF
}
module "vpc" {
  source = "./module/vpc"
}

module "sg" {
  source     = "./module/sg"
  ip_address = var.ip_address

  vpc_id = module.vpc.vpc_id
}

module "bastion_host" {
  source          = "./module/ec2"
  subnet_id       = module.vpc.public_subnet_a_id
  security_groups = [module.sg.bastion_allow_ssh, module.sg.http]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  user_data       = local.user_data
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "bastion"
  }
}

module "private_host" {
  source          = "./module/ec2"
  subnet_id       = module.vpc.private_subnet_a_id
  security_groups = [module.sg.private_ssh]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "db"
  }
}
