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

module "vpn" {
  source = "./modules/vpc"

  name = "saa-c03-vpn"
  azs  = ["eu-west-1a", "eu-west-1b"]
}

module "sns" {
  source = "./modules/sns"

  name       = "saa-c03-sns"
  fifo_topic = false
}
