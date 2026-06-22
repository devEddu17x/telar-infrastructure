variable "name_prefix" {
  description = "Prefix used for naming CDN resources"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "enabled" {
  description = "Enable the CloudFront distribution"
  type        = bool
  default     = true
}

variable "origin_id" {
  description = "Origin identifier"
  type        = string
  default     = "s3-origin"
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy"
  type        = string
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "Allowed HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cached_methods" {
  description = "Cached HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to CDN resources"
  type        = map(string)
  default     = {}
}
