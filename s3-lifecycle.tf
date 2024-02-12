resource "aws_s3_bucket" "saa_tutorial_kody_bucket_rule" {
  bucket = "saa-tutorial-kody-bucket-lifecycle-rule"
}

resource "aws_s3_bucket_lifecycle_configuration" "saa_tutorial_kody_bucket_rule_lifecycle_configuration" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_rule.id

  rule {
    id     = "rule-1"
    status = "Enabled"
    filter {
      prefix = ""
    }
    expiration {
      days                         = 700
      expired_object_delete_marker = false
    }

    noncurrent_version_expiration {
      noncurrent_days = 700
    }
    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }
    transition {
      days          = 180
      storage_class = "GLACIER"
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 365
      storage_class = "DEEP_ARCHIVE"
    }
    transition {
      days          = 60
      storage_class = "INTELLIGENT_TIERING"
    }
    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }
  }
}

