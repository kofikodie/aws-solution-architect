resource "aws_sqs_queue" "saa_c03_sqs" {
  name                       = var.sqs_queue_name
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 20
  fifo_queue                 = var.fifo_queue
  sqs_managed_sse_enabled    = true
}

resource "aws_sqs_queue_policy" "saa_c03_sqs_policy" {
  queue_url = aws_sqs_queue.saa_c03_sqs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.saa_c03_sqs.arn
      }
    ]
  })
}
