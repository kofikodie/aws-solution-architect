variable "name" {
  description = "The AWS region to deploy to"
}

variable "azs" {
  description = "The availability zones"
  type        = list(string)
}
