variable "name_prefix" {
  description = "Prefix for naming all resources"
  type        = string
}

variable "bucket_suffix" {
  description = "Suffix for the bucket name"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket destruction even if it contains objects"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable object versioning"
  type        = bool
  default     = false
}

variable "cors" {
  description = "CORS configuration for the bucket"
  type = object({
    enabled         = optional(bool, true)
    allowed_headers = optional(list(string), ["*"])
    allowed_methods = optional(list(string), ["GET", "PUT", "POST", "DELETE"])
    allowed_origins = list(string)
    max_age_seconds = optional(number, 3000)
  })
}

variable "logging_target_bucket" {
  description = "Name of the target bucket for access logs. Disabled if null"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for access log objects"
  type        = string
  default     = "log/"
}

variable "alb_access_logs_enabled" {
  description = "Enable ALB access log delivery to this bucket"
  type        = bool
  default     = false
}

variable "alb_access_logs_prefix" {
  description = "Prefix for ALB access log objects"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags applied to all storage resources"
  type        = map(string)
  default     = {}
}
