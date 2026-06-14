output "bucket_id" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name for CloudFront or CORS integrations"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_policy_id" {
  description = "ID of the bucket policy"
  value       = var.alb_access_logs_enabled ? aws_s3_bucket_policy.alb_logs[0].id : aws_s3_bucket_policy.https_only[0].id
}
