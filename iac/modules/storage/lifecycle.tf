resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.lifecycle_logs_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id     = "logs-lifecycle"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    expiration {
      days = var.lifecycle_logs_expiration_days
    }

  }
}
