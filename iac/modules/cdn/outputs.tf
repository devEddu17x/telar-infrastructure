output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "origin_access_control_id" {
  description = "ID of the Origin Access Control (OAC) used by CloudFront"
  value       = aws_cloudfront_origin_access_control.this.id
}

output "bucket_policy_document" {
  description = "Complete bucket policy document combining HTTPS enforcement and CloudFront OAC access. Useful when manage_bucket_policy is false."
  value = jsonencode({
    Version   = "2012-10-17"
    Statement = local.bucket_policy_statements
  })
}
