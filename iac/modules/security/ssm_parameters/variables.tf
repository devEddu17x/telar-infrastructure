variable "name_prefix" {
  description = "Project-environment prefix used to namespace SSM parameter paths"
  type        = string
}

variable "parameters" {
  description = "Map of SSM parameter names to their string values"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to all SSM parameters"
  type        = map(string)
  default     = {}
}
