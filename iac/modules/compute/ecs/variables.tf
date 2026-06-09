variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "container_image" {
  description = "Docker image URI"
  type        = string
}

variable "container_port" {
  description = "Port where app container listens"
  type        = number
}

variable "desired_count" {
  description = "Number of tasks to run initially"
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "CPU units per task"
  type        = string
  default     = "1024"
}

variable "task_memory" {
  description = "Memory per task"
  type        = string
  default     = "2048"
}

variable "subnet_ids" {
  description = "Subnet IDs for tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for tasks"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN to register in service"
  type        = string
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to wait before health checks start after task launch"
  type        = number
  default     = 10
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks."
  type        = bool
  default     = false
}

variable "execution_role_arn" {
  description = "IAM role ARN to pull images and write logs"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for container at runtime (S3, Cognito)"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables to inject in container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets to inject in container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "aws_region" {
  description = "AWS region for CloudWatch logs configuration"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags for this module"
  type        = map(string)
  default     = {}
}
