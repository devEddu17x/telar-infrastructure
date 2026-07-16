variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "name" {
  description = "Grafana workspace name"
  type        = string
}

variable "grafana_version" {
  description = "Grafana version for the workspace"
  type        = string
  default     = "12.4"
}

variable "role_arn" {
  description = "IAM role assumed by Amazon Managed Grafana"
  type        = string
}

variable "tags" {
  description = "Tags for the Grafana workspace"
  type        = map(string)
  default     = {}
}
