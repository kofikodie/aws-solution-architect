resource "aws_kinesis_firehose_delivery_stream" "saa_firehose" {
  name        = var.name
  destination = var.destination

  kinesis_source_configuration {
    kinesis_stream_arn = var.data_stream_arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.saa_bucket.arn
    prefix             = "firehose/"
    buffering_size     = 1
    buffering_interval = 60
  }
}

resource "aws_s3_bucket" "saa_bucket" {
  bucket = "kinesis-firehose-saa-bucket"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose_policy"
  description = "Policy for firehose"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Effect = "Allow",
        Resource = [
          aws_s3_bucket.saa_bucket.arn,
          "${aws_s3_bucket.saa_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListStreams"
        ],
        Effect   = "Allow",
        Resource = var.data_stream_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  policy_arn = aws_iam_policy.firehose_policy.arn
  role       = aws_iam_role.firehose_role.name
}
