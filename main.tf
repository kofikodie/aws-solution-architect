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
module "vpc_west" {
  source             = "./module/vpc"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  cidr_block         = "10.0.0.0/16"
}

module "sg_west" {
  source     = "./module/sg"
  ip_address = var.ip_address

  vpc_id = module.vpc_west.vpc_id
}

module "bastion_host_west" {
  source          = "./module/ec2"
  subnet_id       = module.vpc_west.public_subnets[0]
  security_groups = [module.sg_west.bastion_allow_ssh, module.sg_west.http]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  user_data       = local.user_data
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "bastion"
  }
}

module "private_host_west" {
  source          = "./module/ec2"
  subnet_id       = module.vpc_west.private_subnets[0]
  security_groups = [module.sg_west.private_ssh]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "db"
  }
}

module "vpc_central" {
  source             = "./module/vpc"
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  cidr_block         = "10.1.0.0/16"
}

module "sg_central" {
  source     = "./module/sg"
  ip_address = var.ip_address

  vpc_id = module.vpc_central.vpc_id
}

module "web_central" {
  source          = "./module/ec2"
  subnet_id       = module.vpc_central.public_subnets[0]
  security_groups = [module.sg_central.bastion_allow_ssh, module.sg_central.http]
  instance_type   = "t2.micro"
  ami             = "ami-0766b4b472db7e3b9"
  key_name        = data.aws_key_pair.my_key.key_name
  tags = {
    Name = "web"
  }
}
