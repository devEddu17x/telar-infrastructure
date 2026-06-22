variable "bucket_id" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  type        = string
}
