variable "name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "saa-c03-sns"
}

variable "fifo_topic" {
  description = "Whether the SNS topic is FIFO or not"
  type        = bool
  default     = false
}
