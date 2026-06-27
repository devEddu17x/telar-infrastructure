variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Common tags for observability resources"
  type        = map(string)
  default     = {}
}
