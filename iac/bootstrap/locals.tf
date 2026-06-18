locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  state_bucket_name = "${var.project_name}-${var.environment}-${var.aws_region}-${data.aws_caller_identity.current.account_id}--tfstate"
}
