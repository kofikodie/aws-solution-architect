resource "aws_s3_bucket" "saa_tutorial_kody_bucket_class" {
  bucket = "saa-tutorial-kody-bucket-class"
}

resource "aws_s3_object" "saa_tutorial_kody_bucket_folder_class_files" {
  bucket        = aws_s3_bucket.saa_tutorial_kody_bucket_class.id
  storage_class = "ONEZONE_IA"

  for_each = fileset("${path.module}/sync", "**/*")

  key    = each.value
  source = "${path.module}/sync/${each.value}"
}

resource "aws_s3_bucket_lifecycle_configuration" "saa_tutorial_kody_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_class.id

  rule {
    id     = "rule-1"
    status = "Enabled"
    filter {
      prefix = ""
    }
    expiration {
      days = 30
    }
    dynamic "transition" {
      for_each = toset(["STANDARD_IA", "GLACIER"])
      content {
        days          = 1
        storage_class = "GLACIER"
      }
    }
  }
}
