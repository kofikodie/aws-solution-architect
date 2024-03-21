variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "log_destination_type" {
  description = "The type of the log destination"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role to assume"
  default     = ""
}

variable "flow_log_name" {
  description = "The name of the flow log"
  type        = string
}

variable "traffic_type" {
  description = "The type of traffic to capture"
  type        = string
  default     = "ALL"
}

variable "log_destination" {
  description = "The ARN of the log destination"
  type        = string
}
