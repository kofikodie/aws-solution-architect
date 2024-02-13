output "website_url" {
  value = "http://${aws_s3_bucket.saa_tutorial_kody_bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

output "website_url_cors" {
  value = "http://${aws_s3_bucket.saa_tutorial_kody_bucket_cors.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}
