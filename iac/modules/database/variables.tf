variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the Aurora subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the Aurora cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of exactly two availability zones for writer and reader placement"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two availability zones are required"
  }
}
variable "engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "17.7"
}

variable "database_name" {
  description = "Name of the initial database to create"
  type        = string
}

variable "master_username" {
  description = "Master username for the cluster"
  type        = string
  sensitive   = true
}
variable "serverless_min_capacity" {
  description = "Minimum ACU capacity for Aurora Serverless v2"
  type        = number
  default     = 0.5
}

variable "serverless_max_capacity" {
  description = "Maximum ACU capacity for Aurora Serverless v2"
  type        = number
  default     = 16
}

variable "backup_retention_period" {
  description = "Days to retain automated backups"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 1 and 35 days"
  }
}

variable "preferred_backup_window" {
  description = "Daily time range for automated backups in UTC"
  type        = string
  default     = "08:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "Weekly window for maintenance tasks"
  type        = string
  default     = "sun:09:00-sun:10:00"
}

variable "deletion_protection" {
  description = "Protect the cluster from accidental deletion"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on cluster deletion"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds"
  type        = number
  default     = 60

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "monitoring_interval must be 0, 1, 5, 10, 15, 30, or 60"
  }
}

variable "monitoring_role_arn" {
  description = "IAM role ARN for enhanced monitoring"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all database resources"
  type        = map(string)
  default     = {}
}

variable "backup_iam_role_arn" {
  description = "ARN of the IAM role that AWS Backup will assume to perform backup and restore operations on the Aurora cluster"
  type        = string
}

variable "backup_schedule" {
  description = "Cron expression for the AWS Backup plan schedule (UTC). Default: daily at 05:00 UTC"
  type        = string
  default     = "cron(0 5 * * ? *)"
}

variable "backup_retention_days" {
  description = "Number of days to retain AWS Backup recovery points in the vault"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1
    error_message = "backup_retention_days must be at least 1"
  }
}
