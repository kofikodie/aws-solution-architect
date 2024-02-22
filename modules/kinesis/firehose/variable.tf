variable "name" {
  description = "The name of the Kinesis Firehose"
}

variable "destination" {
  description = "The destination of the Kinesis Firehose"
  type        = string
}

variable "data_stream_arn" {
  description = "value of the Kinesis Stream ARN"
  type        = string
}
