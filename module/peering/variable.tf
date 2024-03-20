variable "primary_vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "secondary_vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "primary_main_route_table_id" {
  description = "The main route table ID for the primary VPC"
  type        = string
}

variable "primary_cidr_block" {
  description = "The CIDR block for the primary VPC"
  type        = string
}

variable "secondary_main_route_table_id" {
  description = "The main route table ID for the secondary VPC"
  type        = string
}

variable "secondary_cidr_block" {
  description = "The CIDR block for the secondary VPC"
  type        = string
}
