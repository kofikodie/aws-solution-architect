resource "aws_s3_bucket" "saa_tutorial_kody_bucket" {
  bucket = "saa-tutorial-kody"
}

resource "aws_s3_bucket_versioning" "saa_tutorial_kody_bucket_versioning" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "saa_tutorial_kody_bucket_folder" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket.id

  for_each = fileset("${path.module}/home", "**/*")

  key          = each.value
  source       = "${path.module}/home/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "saa_tutorial_kody_bucket_website" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "saa_tutorial_kody_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.saa_tutorial_kody_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "saa_tutorial_kody_bucket_policy" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.saa_tutorial_kody_bucket.arn}/*",
      },
    ],
  })
}
