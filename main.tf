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
  name   = "saa-c03"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  user_data = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ec2-instance"
  }
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name        = "central-event-bus-v2"
  create_archives = true
  archives = {
    "central-event-bus-archive" = {
      description    = "Central event bus archive"
      retention_days = 7
    }
  }

  rules = {
    central_event_bus_rule = {
      description = "Central event bus rule"
      event_pattern = jsonencode({
        source = ["aws.ec2"]
      })
      state = "ENABLED"
    }
  }

  targets = {
    central_event_bus_rule = [
      {
        name = "central_event_bus_sns"
        arn  = module.sns.topic_arn
        id   = "central_event_bus_sns"
      }
    ]
  }
  create_schemas_discoverer = true
}

module "sns" {
  source = "terraform-aws-modules/sns/aws"

  name = "central-event-bus-sns"

  subscriptions = {
    email = {
      protocol = "email"
      endpoint = "k.kodieaddo@gmail.com"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  tags = local.tags
}

#ami-0766b4b472db7e3b9
