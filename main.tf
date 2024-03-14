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

resource "aws_ssm_parameter" "database_url" {
  name  = "/app/db/url"
  type  = "String"
  value = "mysql://localhost:3306"

  tags = {
    Environment = "dev"
  }
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/app/db/password"
  type  = "SecureString"
  value = var.database_pwd

  tags = {
    Environment = "dev"
  }
}
