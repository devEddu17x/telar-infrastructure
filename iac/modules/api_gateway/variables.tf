variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "api_stage" {
  description = "Stage name"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  type        = string
}

variable "cors_configuration" {
  description = "CORS configuration for the API Gateway"
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(list(string), ["authorization", "content-type"])
    allow_methods     = optional(list(string), ["GET", "POST", "PUT", "DELETE", "OPTIONS"])
    allow_origins     = optional(list(string), [])
    expose_headers    = optional(list(string), [])
    max_age           = optional(number, 300)
  })
  default = {}
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the VPC Link will be deployed"
  type        = list(string)
}

variable "apg_vpc_link_security_group_ids" {
  description = "List of security group IDs for the VPC Link"
  type        = list(string)
}

variable "alb_arn" {
  description = "ARN of the internal ALB for the VPC Link"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the internal ALB"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  type        = string
}

variable "access_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for access logs"
  type        = string
}

variable "api_gateway_cloudwatch_role_arn" {
  description = "ARN of the IAM role used by API Gateway to write CloudWatch Logs"
  type        = string
}

variable "tags" {
  description = "Tags for API Gateway resources"
  type        = map(string)
  default     = {}
}
