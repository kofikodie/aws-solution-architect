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

variable "database_pwd" {
  description = "Database password"
  default     = "password"
}

data "aws_availability_zones" "available" {}
