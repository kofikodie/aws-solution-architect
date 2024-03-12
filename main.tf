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

provider "aws" {
  alias      = "secondary"
  region     = var.aws_secondary_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "vpc_west" {
  source = "./modules/vpc"
  name   = "vpc-west"
  azs    = ["eu-west-1a", "eu-west-1b"]
  providers = {
    aws = aws
  }
}

module "ec2_instance_west" {
  source = "./modules/ec2_instance"

  instance_name = "west-instance"
  ami           = "ami-0766b4b472db7e3b9"
  instance_type = "t2.micro"
  subnet_id     = module.vpc_west.subnet_id[0]
  vpc_id        = module.vpc_west.vpc_id
  providers = {
    aws = aws
  }
}

module "cloudwatch_west" {
  source = "./modules/cloudwatch"

  instance_id = module.ec2_instance_west.instance_id
  region      = var.aws_region
}
