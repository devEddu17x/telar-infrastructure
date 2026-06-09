variable "namespace" {
  description = "AWS service namespace to scale"
  type        = string
  default     = "ecs"
}

variable "dimension" {
  description = "Scalable dimension of the target"
  type        = string
  default     = "ecs:service:DesiredCount"
}

variable "resource" {
  description = "Resource identifier for resource"
  type        = string
}

variable "metric_type" {
  description = "Metric type for target tracking"
  type        = string
  default     = "ECSServiceAverageCPUUtilization"
}

variable "min" {
  description = "Minimum capacity"
  type        = number
  default     = 3
}

variable "max" {
  description = "Maximum capacity"
  type        = number
  default     = 20
}

variable "target" {
  description = "Target value of the metric"
  type        = number
  default     = 70
}