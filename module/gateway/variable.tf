variable "gateway_name" {
  description = "The name of the gateway"
  type        = string
}

variable "resource_path" {
  description = "The path of the resource"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The ARN of the lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the lambda function"
  type        = string
}

variable "http_method" {
  description = "The HTTP method"
  type        = string
}

variable "region" {
  description = "The region"
  type        = string
}

variable "accountId" {
  description = "The account ID"
  type        = string
}
