variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "The availability zones for the VPC"
  type        = list(string)
}

variable "module_id" {
  description = "The module id"
  type        = string
}

variable "name" {
  description = "The name of the VPC"
  type        = string
}

variable "genarate_ipv6_cidr_block" {
  description = "A boolean flag to enable/disable the generation of an IPv6 CIDR block"
  default     = false
}