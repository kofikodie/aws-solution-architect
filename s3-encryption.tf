resource "aws_s3_bucket" "saa_tutorial_kody_bucket_encryption" {
  bucket = "saa-tutorial-kody-bucket-lifecycle-encryption"
}

resource "aws_s3_bucket_versioning" "saa_tutorial_kody_bucket_versioning_encryption" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_encryption.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "saa_key" {
  description             = "SAA Tutorial Kody Key"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_encryption.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.saa_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
