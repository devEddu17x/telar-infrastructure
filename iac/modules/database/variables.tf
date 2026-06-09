variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the Aurora subnet group (persistence subnet)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the Aurora cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for instance placement (e.g. [\"us-east-1a\", \"us-east-1b\"])"
  type        = list(string)
}

# Engine
variable "engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "16.6"
}

variable "parameter_group_family" {
  description = "Parameter group family matching engine version (e.g. aurora-postgresql16)"
  type        = string
  default     = "aurora-postgresql16"
}

# Credentials
variable "database_name" {
  description = "Name of the initial database to create"
  type        = string
}

variable "master_username" {
  description = "Master username for the cluster"
  type        = string
  sensitive   = true
}

variable "master_password" {
  description = "Master password for the cluster. Should be sourced from Secrets Manager output"
  type        = string
  sensitive   = true
}

# Instances
variable "instance_class" {
  description = "DB instance class (e.g. db.t4g.medium, db.r8g.large)"
  type        = string
  default     = "db.t4g.medium"
}

variable "reader_count" {
  description = "Number of reader instances to provision. Set to 0 for dev/qa environments"
  type        = number
  default     = 1
}

# Auto Scaling
variable "auto_scaling_enabled" {
  description = "Enable Aurora Auto Scaling for read replicas"
  type        = bool
  default     = false
}

variable "auto_scaling_min_readers" {
  description = "Minimum number of read replicas when auto-scaling is enabled"
  type        = number
  default     = 1

  validation {
    condition     = var.auto_scaling_min_readers >= 0
    error_message = "auto_scaling_min_readers must be greater than or equal to 0."
  }
}

variable "auto_scaling_max_readers" {
  description = "Maximum number of read replicas when auto-scaling is enabled"
  type        = number
  default     = 3

  validation {
    condition     = var.auto_scaling_max_readers >= 0 && var.auto_scaling_max_readers >= var.auto_scaling_min_readers
    error_message = "auto_scaling_max_readers must be greater than or equal to auto_scaling_min_readers and >= 0."
  }
}

variable "auto_scaling_cpu_target" {
  description = "Target average CPU utilization percentage for auto-scaling"
  type        = number
  default     = 70
}

variable "auto_scaling_connections_target" {
  description = "Target average database connections per vCPU for auto-scaling"
  type        = number
  default     = 100
}

# Encryption
variable "kms_key_id" {
  description = "ARN of the KMS key for storage encryption. Defaults to AWS-managed key if null"
  type        = string
  default     = null
}

# Backup
variable "backup_retention_period" {
  description = "Days to retain automated backups (1-35)"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 1 and 35 days."
  }
}

variable "preferred_backup_window" {
  description = "Daily time range for automated backups (UTC). e.g. 03:00-04:00"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Weekly window for maintenance tasks. e.g. sun:05:00-sun:06:00"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

# Lifecycle
variable "deletion_protection" {
  description = "Protect the cluster from accidental deletion. Recommended true for prod"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on cluster deletion. Set false for prod"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine upgrades during maintenance window"
  type        = bool
  default     = true
}

# Monitoring
variable "performance_insights_enabled" {
  description = "Enable Performance Insights on all instances"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Retention period for Performance Insights data in days (7 or 731)"
  type        = number
  default     = 7

  validation {
    condition     = contains([7, 731], var.performance_insights_retention_period)
    error_message = "performance_insights_retention_period must be either 7 or 731."
  }
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 to disable, or 1/5/10/15/30/60)"
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "monitoring_interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "monitoring_role_arn" {
  description = "ARN of the IAM role for enhanced monitoring. Required when monitoring_interval > 0"
  type        = string
  default     = null
}

# Parameters
variable "cluster_parameters" {
  description = "List of DB cluster parameter overrides"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all database resources"
  type        = map(string)
  default     = {}
}
