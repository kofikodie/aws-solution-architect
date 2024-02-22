variable "name" {
  description = "The name of the Kinesis stream"
  type        = string
}

variable "shared_count" {
  description = "The number of shards for the Kinesis stream"
  type        = number
  default     = 1
}
