resource "aws_s3_bucket" "saa_tutorial_kody_bucket_cors" {
  bucket = "saa-tutorial-kody-cors"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id

  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://saa-tutorial-kody.s3-website.eu-west-1.amazonaws.com"]
    expose_headers  = [""]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_versioning" "saa_tutorial_kody_bucket_cors_versioning" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "saa_tutorial_kody_bucket_cors_files" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id

  for_each = fileset("${path.module}/home-extra", "**/*")

  key          = each.value
  source       = "${path.module}/home-extra/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "saa_tutorial_kody_bucket_cors_website" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "saa_tutorial_kody_bucket_cors_policy" {
  bucket = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.saa_tutorial_kody_bucket_cors.arn}/*",
      },
    ],
  })
}

resource "aws_s3_bucket_public_access_block" "saa_tutorial_kody_bucket_cors_public_access_block" {
  bucket                  = aws_s3_bucket.saa_tutorial_kody_bucket_cors.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
