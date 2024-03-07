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

module "gateway" {
  source = "./module/gateway"

  gateway_name         = "terraform_api_gateway"
  resource_path        = "hello"
  http_method          = "POST"
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.name
  region               = var.aws_region
  accountId            = var.aws_account_id
}

output "gateway_url" {
  value = "http://${module.gateway.gateway_url}/dev/hello"
}
