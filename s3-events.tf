resource "aws_s3_bucket" "saa_tutorial_kody_bucket_event" {
  bucket = "saa-tutorial-kody-bucket-event"
}

resource "aws_sqs_queue" "queue" {
  name = "s3-event-notification-queue"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*"
        "Action" : "sqs:SendMessage",
        "Resource" : "arn:aws:sqs:*:*:s3-event-notification-queue",

      }
    ]
  })
}


resource "aws_s3_bucket_notification" "saa_tutorial_kody_bucket_event_notification" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_event.id

  queue {
    queue_arn = aws_sqs_queue.queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
