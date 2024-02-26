variable "name" {
  description = "The name of the load balancer"
  type        = string
}

variable "internal" {
  description = "If the load balancer should be internal"
  type        = bool
}

variable "subnet_ids" {
  description = "The subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "The security group ID"
  type        = string
}

variable "port" {
  description = "The port the load balancer should listen on"
  type        = number
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}
