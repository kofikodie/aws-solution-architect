variable "name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "asg_arn" {
  description = "The ARN of the autoscaling group"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "The security group ID"
  type        = string
}

variable "alb_target_group_arn" {
  description = "The ARN of the target group"
  type        = string
}
