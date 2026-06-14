variable "aws_region" {
  description = "AWS region where bootstrap resources are provisioned"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS shared config profile name"
  type        = string
  default     = null
}

variable "project_name" {
  description = "Project identifier used in naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment identifier for bootstrap resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of two Availability Zones"
  type        = list(string)
}

variable "compute_subnet_cidrs" {
  description = "Map of AZ to CIDR for compute subnets"
  type        = map(string)
}

variable "persistence_subnet_cidrs" {
  description = "Map of AZ to CIDR for persistence subnets"
  type        = map(string)
}

variable "ecs_container_port" {
  description = "Port exposed by ECS Fargate containers"
  type        = number
}
variable "s3_images_force_destroy" {
  description = "Allow bucket destruction even if it contains objects"
  type        = bool
}
variable "s3_images_cors" {
  description = "CORS configuration for the images bucket"
  type = object({
    enabled         = optional(bool, true)
    allowed_headers = optional(list(string), ["*"])
    allowed_methods = optional(list(string), ["GET", "PUT", "POST", "DELETE"])
    allowed_origins = list(string)
    max_age_seconds = optional(number, 3000)
  })
}

variable "s3_images_versioning_enabled" {
  description = "Enable object versioning for the images bucket"
  type        = bool
}

variable "firewall_rate_limits" {
  description = "Each entry creates one rule and one regex pattern set."
  type = list(object({
    name           = string
    limit          = number
    regex_patterns = list(string)
  }))
  default = []
}

variable "firewall_cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics"
  type        = bool
  default     = true
}

variable "firewall_sampled_requests_enabled" {
  description = "Enable sampled requests logging"
  type        = bool
  default     = true
}

variable "firewall_log_destination_arns" {
  description = "ARNs of WAF logging destinations"
  type        = list(string)
  default     = []
}

variable "firewall_redacted_fields" {
  description = "HTTP header names to redact from WAF logs"
  type        = list(string)
  default     = []
}
