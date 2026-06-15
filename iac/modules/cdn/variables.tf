variable "name_prefix" {
  description = "Prefix used for naming CDN resources"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket that CloudFront will use as origin. Normally exported from the storage module."
  type        = string
}

variable "bucket_id" {
  description = "ID (name) of the S3 bucket that CloudFront will front. Normally exported from the storage module."
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket that CloudFront will front. Normally exported from the storage module."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class. Allowed values: PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = "PriceClass_100"
}

variable "enabled" {
  description = "Whether the CloudFront distribution is enabled"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Object returned when the root URL is requested"
  type        = string
  default     = "index.html"
}

variable "origin_id" {
  description = "Unique identifier for the origin within this distribution"
  type        = string
  default     = "s3-origin"
}

variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers. Allowed values: allow-all, https-only, redirect-to-https"
  type        = string
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "HTTP methods that CloudFront processes and forwards to the origin"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "HTTP methods for which CloudFront caches responses"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "manage_bucket_policy" {
  description = "If true, this module will attach a bucket policy that allows CloudFront OAC and enforces HTTPS. Disable if the bucket policy is managed elsewhere."
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for the CloudFront distribution. Defaults to a generated value if not provided."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to all CDN resources"
  type        = map(string)
  default     = {}
}
