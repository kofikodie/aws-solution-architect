variable "sqs_queue_name" {
  description = "The name of the SQS queue"
  type        = string
  default     = "saa-c03-sqs"
}

variable "fifo_queue" {
  description = "Boolean to indicate if the queue is FIFO"
  type        = bool
  default     = false
}
