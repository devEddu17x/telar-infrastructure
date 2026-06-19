variable "name_prefix" {
  description = "Prefix for naming all resources in this module"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the Cognito User Pool is deployed"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile name used for local-exec provisioners. Leave empty to use the default profile"
  type        = string
  default     = ""
}

variable "repository_url" {
  description = "HTTPS URL of the GitHub/GitLab repository containing the Next.js frontend source code"
  type        = string
}

variable "github_access_token" {
  description = "Personal Access Token with repo and admin:repo_hook scopes. Leave empty when using the Amplify GitHub App connection"
  type        = string
  sensitive   = true
  default     = ""
}

variable "branch" {
  description = "Git branch to deploy (e.g. main, dev)"
  type        = string
  default     = "develop"
}

variable "framework" {
  description = "Framework used for the frontend application"
  type        = string
  default     = "Next.js - SSR"
}

variable "branch_stage" {
  description = "Amplify stage for the deployed branch (DEVELOPMENT, QA, PRODUCTION)"
  type        = string
  default     = "PRODUCTION"

  validation {
    condition     = contains(["DEVELOPMENT", "QA", "PRODUCTION"], var.branch_stage)
    error_message = "branch_stage must be DEVELOPMENT, QA or PRODUCTION"
  }
}

variable "node_version" {
  description = "Node.js version to use in the Amplify build environment"
  type        = string
  default     = "20"
}

variable "domain_name" {
  description = "Custom domain managed by Route 53 to associate with the Amplify app (e.g. example.com). Leave empty to skip domain association."
  type        = string
  default     = ""
}

variable "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL (scope CLOUDFRONT) to associate with the Amplify distribution"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Map of environment variables to inject into the Amplify app. The module always adds _LIVE_UPDATES automatically."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources in this module"
  type        = map(string)
  default     = {}
}
