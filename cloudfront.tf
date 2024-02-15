resource "aws_s3_bucket" "static_bucket_website" {
  bucket = "static-website-bucket-kody"

  tags = {
    Name = "static-website-bucket-kody"
  }
}

resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.static_bucket_website.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.static_bucket_website.arn,
          "${aws_s3_bucket.static_bucket_website.arn}/*"
        ],
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "static_bucket_versioning" {
  bucket = aws_s3_bucket.static_bucket_website.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "static_bucket_objects" {
  bucket = aws_s3_bucket.static_bucket_website.id

  for_each = fileset("${path.module}/home", "**/*")

  key          = each.value
  source       = "${path.module}/home/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_bucket_acl" "static_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  bucket     = aws_s3_bucket.static_bucket_website.id

  acl = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_bucket_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

locals {
  s3_origin_id = "myS3Origin"
}


resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "static-website-bucket-kody"
  description                       = "Access control for my S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_bucket_website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  comment             = "Some comment"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IT"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
