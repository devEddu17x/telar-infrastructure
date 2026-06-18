resource "aws_s3_bucket_cors_configuration" "this" {
  count  = var.cors.enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id
  cors_rule {
    allowed_headers = var.cors.allowed_headers
    allowed_methods = var.cors.allowed_methods
    allowed_origins = var.cors.allowed_origins
    max_age_seconds = var.cors.max_age_seconds
  }
}
