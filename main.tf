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

resource "aws_secretsmanager_secret" "saa_c03" {
  name = "prod/saa-c03"
}

resource "aws_secretsmanager_secret_version" "saa_c03" {
  secret_id = aws_secretsmanager_secret.saa_c03.id
  secret_string = jsonencode({
    name  = "solution-architect-associate",
    alias = "saa-c03",
  })
}
