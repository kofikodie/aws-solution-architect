variable "subnet_id" {
  description = "The subnet ID to launch in"
  type        = string
}

variable "ami" {
  description = "The AMI to use"
  type        = string
}

variable "security_groups" {
  description = "The security group IDs"
  type        = list(string)
}

variable "tags" {
  description = "The tags to apply to the instance"
  type        = map(string)
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}