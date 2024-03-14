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

data "aws_caller_identity" "current" {}

locals {
  name             = "kms-saa-c03"
  current_identity = data.aws_caller_identity.current.arn

  tags = {
    Name       = local.name
    Example    = "complete"
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-kms"
  }
}

module "kms_complete" {
  source = "terraform-aws-modules/kms/aws"

  description             = "Complete KMS key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_default_policy    = true
  key_owners               = [local.current_identity]
  key_administrators       = [local.current_identity]
  key_users                = [local.current_identity]

  aliases = ["${local.name}"]

  tags = local.tags
}
