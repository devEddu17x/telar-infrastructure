variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "scope" {
  description = "Scope of the Web ACL. Use REGIONAL for API Gateway, ALB or AppSync; CLOUDFRONT only for CloudFront distributions"
  type        = string
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "default_action" {
  description = "Default action when no rule matches the request (allow or block)"
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "default_action must be either allow or block."
  }
}

variable "rate_limit" {
  description = "Maximum number of requests allowed from a single IP within a 5-minute sliding window before being blocked (DDoS mitigation)"
  type        = number
  default     = 2000

  validation {
    condition     = var.rate_limit >= 10 && var.rate_limit <= 2000000000
    error_message = "rate_limit must be between 10 and 2,000,000,000 requests."
  }
}

variable "common_rule_set_count_only" {
  description = "If true, the AWSManagedRulesCommonRuleSet group runs in count (observation) mode instead of blocking"
  type        = bool
  default     = false
}

variable "common_rule_set_count_overrides" {
  description = "List of individual rule names inside AWSManagedRulesCommonRuleSet to force into count mode while the rest keep blocking"
  type        = list(string)
  default     = []
}

variable "cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics for the Web ACL and each of its rules"
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Store a sample of the requests inspected by the Web ACL and its rules (visible in the WAF console)"
  type        = bool
  default     = true
}

variable "log_destination_arns" {
  description = "ARNs of the WAF logging destinations (CloudWatch Logs log group, Kinesis Firehose or S3) provisioned by the observability module. A CloudWatch log group name MUST start with 'aws-waf-logs-'."
  type        = list(string)
  default     = []
}

variable "logging_redacted_fields" {
  description = "List of HTTP header names to redact from the WAF logs to avoid storing sensitive data"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the WAFv2 Web ACL"
  type        = map(string)
  default     = {}
}