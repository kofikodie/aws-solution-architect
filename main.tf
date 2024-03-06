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

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/src/"
  output_path = "${path.module}/src/hello-python.zip"

}

module "role" {
  source = "./module/role"

  role_name          = "lambda_role"
  name_policy        = "iam_policy_for_lambda"
  policy_description = "Policy for lambda"
}


module "lambda" {
  source = "./module/lambda"

  filename                      = "${path.module}/src/hello-python.zip"
  function_name                 = "terraform_lambda_func"
  role_arn                      = module.role.role_arn
  handler                       = "index.lambda_handler"
  runtime                       = "python3.8"
  attach_iam_policy_to_iam_role = module.role.policy_attachment
}
