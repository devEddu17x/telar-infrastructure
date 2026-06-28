variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}

variable "tags" {
  description = "Common tags for observability resources"
  type        = map(string)
  default     = {}
}
