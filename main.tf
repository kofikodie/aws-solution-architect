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

resource "aws_api_gateway_rest_api" "saa_c03_gw" {
  name = "saa-c03-gw"

  endpoint_configuration {
    types = ["EDGE"]
  }
}


resource "aws_api_gateway_resource" "saa_c03_gw_resource" {
  parent_id   = aws_api_gateway_rest_api.saa_c03_gw.root_resource_id
  path_part   = "gifts"
  rest_api_id = aws_api_gateway_rest_api.saa_c03_gw.id
}

resource "aws_api_gateway_method" "saa_c03_gw_method" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.saa_c03_gw_resource.id
  rest_api_id   = aws_api_gateway_rest_api.saa_c03_gw.id
}

resource "aws_api_gateway_integration" "saa_c03_gw_integration" {
  http_method = aws_api_gateway_method.saa_c03_gw_method.http_method
  resource_id = aws_api_gateway_resource.saa_c03_gw_resource.id
  rest_api_id = aws_api_gateway_rest_api.saa_c03_gw.id
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.saa_c03_gw.id
  resource_id = aws_api_gateway_resource.saa_c03_gw_resource.id
  http_method = aws_api_gateway_method.saa_c03_gw_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.saa_c03_gw.id
  resource_id = aws_api_gateway_resource.saa_c03_gw_resource.id
  http_method = aws_api_gateway_method.saa_c03_gw_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = {
    "application/json" = jsonencode({
      message = "Hello from the API Gateway!"
    })
  }
}
