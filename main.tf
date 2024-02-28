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

  name           = "saa-c03-sg"
  vpc_id         = module.vpc.vpc_id
  container_port = 80
}

module "asg" {
  source = "./modules/asg"

  ecs_service_name = module.ecs.aws_ecs_service_name
  ecs_cluster_name = module.ecs.aws_ecs_cluster_name
}

module "ecs" {
  source = "./modules/ecs"

  name                 = "SaaC03EcsCluster"
  subnet_ids           = module.vpc.subnet_ids
  sg_id                = module.sg.sg_ecs_id
  alb_target_group_arn = module.alb.alb_target_group_arn
}

module "alb" {
  source = "./modules/alb"

  name       = "saa-c03-alb"
  internal   = false
  subnet_ids = module.vpc.subnet_ids
  sg_id      = module.sg.sg_alb_id
  port       = 80
  vpc_id     = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}
