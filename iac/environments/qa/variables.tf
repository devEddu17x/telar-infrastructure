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

variable "db_engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
}

variable "db_name" {
  description = "Name of database"
  type        = string
}

variable "db_master_username" {
  description = "Master username for the cluster"
  type        = string
  sensitive   = true
}

variable "db_min_capacity" {
  description = "Minimum ACU capacity for Aurora Serverless v2"
  type        = number
}
variable "db_max_capacity" {
  description = "Maximum ACU capacity for Aurora Serverless v2"
  type        = number
}

variable "db_backup_retention_period" {
  description = "Days to retain automated backups"
  type        = number
}
variable "db_backup_window" {
  description = "Daily time range for automated backups in UTC"
  type        = string
  default     = "08:00-09:00"
}

variable "db_maintenance_window" {
  description = "Weekly window for maintenance tasks"
  type        = string
  default     = "sun:09:00-sun:10:00"
}

variable "db_deletion_protection" {
  description = "Protect the cluster from accidental deletion"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on cluster deletion"
  type        = bool
  default     = true
}

variable "db_monitoring_interval" {
  description = "Enhanced monitoring interval in seconds"
  type        = number
  default     = 60

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.db_monitoring_interval)
    error_message = "db_monitoring_interval must be 0, 1, 5, 10, 15, 30, or 60"
  }
}

variable "db_backup_schedule" {
  description = "Cron expression for the AWS Backup plan schedule"
  type        = string
  default     = "cron(0 5 * * ? *)"
}

variable "db_backup_vault_retention_days" {
  description = "Days to retain AWS Backup recovery points"
  type        = number
  default     = 7
}
