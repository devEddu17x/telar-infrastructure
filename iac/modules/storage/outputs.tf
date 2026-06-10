output "bucket_id" {
  description = "El nombre (ID) del bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "El ARN del bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "El nombre de dominio regional del bucket, útil para integraciones con CloudFront o CORS"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}