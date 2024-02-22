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

module "kinesis" {
  source = "./modules/kinesis/streams"

  name = "saa-c03-kinesis"
}

module "firehose" {
  source = "./modules/kinesis/firehose"

  name            = "saa-c03-firehose"
  destination     = "extended_s3"
  data_stream_arn = module.kinesis.data_stream_arn
}
