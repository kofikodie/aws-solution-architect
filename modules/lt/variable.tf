variable "name" {
  description = "The name of the ECS cluster"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "image_id" {
  description = "The AMI ID"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "The instance type"
  default     = "t2.micro"
}

variable "ecs_launch_config_name" {
  description = "The name of the ECS launch configuration"
  default     = "ecs-launch-config"
}

variable "sg_id" {
  description = "The security group ID"
}
