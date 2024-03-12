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
      enabled = true
    }
  }

  targets = {
    central_event_bus_target = [
      {
        arn = aws_sns_topic.central_event_bus_sns.arn
        id  = "central_event_bus_sns"
      }
    ]
  }
  create_schemas_discoverer = true
}
