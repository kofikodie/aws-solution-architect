variable "policy_name" {
  description = "The name of the policy"
  type        = string
}

variable "policy_document" {
  description = "The policy document"
  type        = string
}

variable "role_name" {
  description = "The name of the role"
  type        = string
}

variable "assume_role_policy" {
  description = "The assume role policy"
  type        = string
}