resource "aws_kinesis_stream" "my_stream" {
  name        = var.name
  shard_count = var.shared_count

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
