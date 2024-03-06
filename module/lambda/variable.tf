variable "function_name" {
  description = "The name of the function"
  type        = string
}

variable "filename" {
  description = "The filename of the function"
  type        = string
}

variable "handler" {
  description = "The handler of the function"
  type        = string
}

variable "runtime" {
  description = "The runtime of the function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the role"
  type        = string
}

variable "attach_iam_policy_to_iam_role" {
  description = "The attachment of the policy to the role"
  type        = any
}
