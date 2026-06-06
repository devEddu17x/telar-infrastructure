variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB and target group"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "alb" {
  description = "ALB listener configuration (port exposed to API Gateway via VPC Link)"
  type = object({
    port     = optional(number, 80)
    protocol = optional(string, "HTTP")
  })
  default = {}
}

variable "target_group" {
  description = "Target group configuration. Must match ECS task definition."
  type = object({
    port        = optional(number, 3000)
    protocol    = optional(string, "HTTP")
    target_type = optional(string, "ip")
  })
  default = {}
}

variable "health_check" {
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

variable "deregistration_delay" {
  description = "Delay in seconds before removing a target"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags for this module"
  type        = map(string)
  default     = {}
}
