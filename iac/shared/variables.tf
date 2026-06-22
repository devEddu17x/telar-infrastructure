variable "aws_region" {
  description = "AWS region where shared resources are provisioned"
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
  description = "Environment identifier for shared resources"
  type        = string
  default     = "shared"
}

variable "github_oidc_thumbprints" {
  description = "Thumbprints for the GitHub OIDC provider"
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "frontend_github_repository" {
  description = "GitHub repository that deploys the frontend"
  type        = string
}

variable "frontend_github_branches" {
  description = "Git branches allowed to deploy the frontend"
  type        = list(string)
  default     = []
}

variable "frontend_github_environments" {
  description = "GitHub environments allowed to deploy the frontend"
  type        = list(string)
  default     = ["dev"]
}

variable "frontend_parameter_path" {
  description = "Frontend SSM parameter path under each environment prefix"
  type        = string
  default     = "frontend"
}

variable "frontend_bucket_suffixes" {
  description = "Frontend bucket suffixes the role can deploy to"
  type        = list(string)
  default     = ["system-frontend"]
}

variable "backend_github_repository" {
  description = "GitHub repository that deploys the backend"
  type        = string
}

variable "backend_github_branches" {
  description = "Git branches allowed to deploy the backend"
  type        = list(string)
  default     = []
}

variable "backend_github_environments" {
  description = "GitHub environments allowed to deploy the backend"
  type        = list(string)
  default     = ["dev"]
}

variable "backend_parameter_path" {
  description = "Backend deploy SSM parameter path under each environment prefix"
  type        = string
  default     = "backend/deploy"
}
