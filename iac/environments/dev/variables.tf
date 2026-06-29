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


variable "ecr_force_delete" {
  description = "Allow repository deletion with images"
  type        = bool
  default     = true
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
  default     = true
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

variable "db_backup_vault_force_destroy" {
  description = "Delete recovery points when destroying the backup vault"
  type        = bool
  default     = true
}

variable "cognito_internal_auth_token" {
  description = "Internal auth token used by the backend for Cognito admin operations"
  type = object({
    value          = string
    retention_days = number
  })
  sensitive = true
}

variable "backend_env" {
  description = "Static non-sensitive backend configuration stored in SSM Parameter Store"
  type        = map(string)
}

variable "balancer_deletion_protection" {
  description = "Deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "balancer_alb" {
  description = "ALB listener configuration (port exposed to API Gateway via VPC Link)"
  type = object({
    port     = optional(number, 80)
    protocol = optional(string, "HTTP")
  })
  default = {}
}

variable "balancer_target_group" {
  description = "Target group configuration. Must match ECS task definition."
  type = object({
    port        = optional(number, 3000)
    protocol    = optional(string, "HTTP")
    target_type = optional(string, "ip")
  })
  default = {}
}

variable "balancer_health_check" {
  description = "Health check for the target group. Must match ECS task definition."
  type = object({
    enabled             = optional(bool, true)
    path                = optional(string, "/health")
    protocol            = optional(string, "HTTP")
    port                = optional(string, "traffic-port")
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
    interval            = optional(number, 30)
    timeout             = optional(number, 5)
    matcher             = optional(string, "200")
  })
  default = {}
}

variable "balancer_deregistration_delay" {
  description = "Delay in seconds before removing a target"
  type        = number
  default     = 30
}

variable "balancer_logs_force_destroy" {
  description = "Allow bucket destruction even if it contains objects"
  type        = bool
}

variable "api_stage" {
  description = "API Gateway stage name"
  type        = string
}

variable "api_prefix" {
  description = "First path segment of the API route tree"
  type        = string
  default     = "api"
}

variable "api_version" {
  description = "Version path segment of the API route tree"
  type        = string
  default     = "v1"
}

variable "api_cors_configuration" {
  description = "CORS configuration for API Gateway"
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

variable "ecs_container_image" {
  description = "Optional Docker image URI for the API"
  type        = string
  default     = null

  validation {
    condition     = var.ecs_container_image == null || trimspace(var.ecs_container_image) != ""
    error_message = "ecs_container_image must be null or a non-empty Docker image URI"
  }
}

variable "ecs_desired_count" {
  description = "Initial number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_task_cpu" {
  description = "CPU units per task"
  type        = string
  default     = "1024"
}

variable "ecs_task_memory" {
  description = "Memory per task"
  type        = string
  default     = "2048"
}

variable "ecs_auto_scaling" {
  description = "Auto scaling configuration for ECS service"
  type = object({
    min         = optional(number, 1)
    max         = optional(number, 4)
    target      = optional(number, 70)
    metric_type = optional(string, "ECSServiceAverageCPUUtilization")
  })
  default = {}
}

variable "frontend_system_static" {
  description = "Static hosting settings for the system frontend"
  type = object({
    enabled       = optional(bool, true)
    force_destroy = optional(bool, false)
    price_class   = optional(string, "PriceClass_100")
  })
  default = {}
}

variable "landing_page_static" {
  description = "Static hosting settings for the landing page"
  type = object({
    enabled       = optional(bool, true)
    force_destroy = optional(bool, false)
    price_class   = optional(string, "PriceClass_100")
  })
  default = {}
}
variable "images_static" {
  description = "Static hosting settings for the images"
  type = object({
    enabled       = optional(bool, true)
    force_destroy = optional(bool, false)
    price_class   = optional(string, "PriceClass_100")
  })
  default = {}
}
