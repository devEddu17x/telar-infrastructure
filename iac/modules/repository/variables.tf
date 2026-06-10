variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable image vulnerability scanning on every push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the repository (AES256 or KMS)"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be either AES256 or KMS."
  }
}

variable "kms_key_id" {
  description = "ARN of the KMS key to use when encryption_type is KMS"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all repository resources"
  type        = map(string)
  default     = {}
}
