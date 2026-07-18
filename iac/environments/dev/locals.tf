locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  name_prefix = "${var.project_name}-${var.environment}"

  upper_project_name = "${upper(substr(var.project_name, 0, 1))}${substr(var.project_name, 1, length(var.project_name) - 1)}"
}
