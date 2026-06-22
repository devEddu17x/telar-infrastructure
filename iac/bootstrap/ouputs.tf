output "backend_config_" {
  description = "Example backend values to place in environment backend.hcl files"
  value = {
    bucket  = aws_s3_bucket.terraform_state.id
    key     = "${var.project_name}/${var.environment}/terraform.tfstate"
    region  = var.aws_region
    encrypt = true
  }
}
