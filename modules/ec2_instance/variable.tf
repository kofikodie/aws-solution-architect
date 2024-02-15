variable "ami" {
  description = "The AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
}

variable "subnet_id" {
  description = "The subnet ID for the EC2 instance"
}

variable "vpc_id" {
  description = "The VPC ID"
}
