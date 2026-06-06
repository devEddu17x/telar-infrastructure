variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "api_prefix" {
  description = "API path prefix"
  type        = string
}

variable "api_version" {
  description = "API version"
  type        = string
}

variable "api_stage" {
  description = "Stage name (dev, qa, prod)"
  type        = string
}

variable "cognito_user_pool_issuer_url" {
  description = "Issuer URL of the Cognito User Pool"
  type        = string
}

variable "cognito_user_pool_client_ids" {
  description = "List of Client IDs from the Cognito User Pool allowed by the JWT authorizer"
  type        = list(string)
}

variable "routes" {
  description = "List of routes to expose through the API Gateway"
  type = list(object({
    route_key          = string
    authorization_type = string
  }))
  default = []
}

variable "cors_configuration" {
  description = "CORS configuration for the API Gateway"
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(list(string), ["authorization", "content-type"])
    allow_methods     = optional(list(string), ["GET", "POST", "PUT", "DELETE", "OPTIONS"])
    allow_origins     = optional(list(string), ["*"])
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

variable "alb_listener_arn" {
  description = "ARN of the ALB listener that the integration will target"
  type        = string
}

variable "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL to associate with the API Gateway stage"
  type        = string
}

variable "access_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for access logs"
  type        = string
}

variable "access_log_format" {
  description = "JSON format for access logs"
  type        = string
}

variable "tags" {
  description = "Tags to Api Gateway"
  type        = map(string)
  default     = {}
}
