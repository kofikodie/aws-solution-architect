resource "aws_s3_bucket" "saa_tutorial_kody_bucket-origin-v2" {
  bucket = "saa-tutorial-kody-bucket-origin-v2"
}

resource "aws_s3_bucket_versioning" "saa_tutorial_kody_bucket_versioning-v2" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket-origin-v2.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "saa_tutorial_kody_bucket-replica-v2" {
  bucket = "saa-tutorial-kody-bucket-replica-v2"
}

resource "aws_s3_bucket_versioning" "saa_tutorial_kody_bucket_versioning-replica-v2" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket-replica-v2.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "saa_tutorial_kody_bucket_folder-origin-v2" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket-origin-v2.id

  for_each = fileset("${path.module}/sync", "**/*")

  key    = each.value
  source = "${path.module}/sync/${each.value}"
}


resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.saa_tutorial_kody_bucket_versioning-v2]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket-origin-v2.id

  rule {
    id = "rule-1"
    delete_marker_replication {
      status = "Enabled"
    }
    filter {
      prefix = "/"
    }
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.saa_tutorial_kody_bucket-replica-v2.arn
      storage_class = "STANDARD"
    }
  }
}
