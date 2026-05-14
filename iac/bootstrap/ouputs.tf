output "backend_config_" {
  description = "Example backend values to place in environment backend.hcl files"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
    key            = "${var.project_name}/${var.environment}/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
  }
}
