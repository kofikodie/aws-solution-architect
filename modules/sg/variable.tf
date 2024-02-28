variable "name" {
  description = "The name of the ECS cluster"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "container_port" {
  description = "The port the container listens on"
}
