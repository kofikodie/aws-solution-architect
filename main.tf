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

module "vpc" {
  source = "./modules/vpc"

  name = "saa-c03-vpn"
  azs  = ["eu-west-1a", "eu-west-1b"]
}

module "sg" {
  source = "./modules/sg"

  name   = "saa-c03-sg"
  vpc_id = module.vpc.vpc_id
}

module "launch_template" {
  source = "./modules/lt"

  name          = "saa-c03-lt"
  image_id      = "ami-0323d48d3a525fd18"
  instance_type = "t3.medium"
  sg_id         = module.sg.sg_id
  vpc_id        = module.vpc.vpc_id
}

module "asg" {
  source = "./modules/asg"

  ecs_lt_id  = module.launch_template.lt_id
  subnet_ids = module.vpc.subnet_ids
}

module "ecs" {
  source = "./modules/ecs"

  name                 = "SaaC03EcsCluster"
  asg_arn              = module.asg.asg_arn
  subnet_ids           = module.vpc.subnet_ids
  sg_id                = module.sg.sg_id
  alb_target_group_arn = module.alb.alb_target_group_arn
}

module "alb" {
  source = "./modules/alb"

  name       = "saa-c03-alb"
  internal   = false
  subnet_ids = module.vpc.subnet_ids
  sg_id      = module.sg.sg_id
  port       = 80
  vpc_id     = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}
