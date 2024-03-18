variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_secondary_region" {
  default = "eu-central-1"
}

variable "aws_account_id" {
  description = "AWS account ID"
}

data "aws_availability_zones" "available" {}

data "aws_key_pair" "my_key" {
  key_name = "bh_key_pair"
}
