provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  alias      = "central"
  region     = var.aws_secondary_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
