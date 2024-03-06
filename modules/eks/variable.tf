variable "cluster_name" {
  description = "The name of the EKS cluster"
}

variable "public_eu_west_1a_subnet_id" {
  description = "The ID of the public subnet in eu-west-1a"
}

variable "public_eu_west_1b_subnet_id" {
  description = "The ID of the public subnet in eu-west-1b"
}

variable "private_eu_west_1a_subnet_id" {
  description = "The ID of the private subnet in eu-west-1a"
}

variable "private_eu_west_1b_subnet_id" {
  description = "The ID of the private subnet in eu-west-1b"
}
