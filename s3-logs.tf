resource "aws_s3_bucket" "saa_tutorial_kody_bucket_logs_origin" {
  bucket = "saa-tutorial-kody-bucket-logs-origin"
}

resource "aws_s3_bucket_ownership_controls" "origin_bucket_ownership" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs_origin.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "origin_logs_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.origin_bucket_ownership]

  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs_origin.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "origin_logs_access_block" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs_origin.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket" "saa_tutorial_kody_bucket_logs" {
  bucket = "saa-tutorial-kody-bucket-logs"
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket_ownership" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.logs_bucket_ownership]

  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "logs_access_block" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_logging" "log_bucket_logging" {
  bucket        = aws_s3_bucket.saa_tutorial_kody_bucket_logs_origin.id
  target_bucket = aws_s3_bucket.saa_tutorial_kody_bucket_logs.id
  target_prefix = "logs/"
}
