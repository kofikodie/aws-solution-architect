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


resource "aws_s3_bucket" "main_bucket" {
  bucket = "saa-c03-bucket"
}

resource "aws_athena_database" "main_athena_database" {
  name   = "saa_c03_database"
  bucket = aws_s3_bucket.main_bucket.id
}
