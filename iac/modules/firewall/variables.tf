variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "scope" {
  description = "Scope of the Web ACL (REGIONAL for API Gateway, CLOUDFRONT for CloudFront/Amplify)"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "scope must be REGIONAL or CLOUDFRONT"
  }
}

variable "rate_limits" {
  description = "Each entry creates one rule and one regex pattern set."
  type = list(object({
    name           = string
    limit          = number
    regex_patterns = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for rl in var.rate_limits : length(rl.regex_patterns) > 0])
    error_message = "Each rate limit must have at least one regex pattern"
  }
}

variable "cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics"
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Enable sampled requests logging"
  type        = bool
  default     = true
}

variable "log_destination_arns" {
  description = "ARNs of WAF logging destinations (Kinesis Firehose)"
  type        = list(string)
  default     = []
}

variable "logging_redacted_fields" {
  description = "HTTP header names to redact from WAF logs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all WAF resources"
  type        = map(string)
  default     = {}
}
