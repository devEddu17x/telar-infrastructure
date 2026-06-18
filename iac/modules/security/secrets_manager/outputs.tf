output "secret_arn" {
  description = "ARN of the secret. Pass to ecs_execution_secrets_manager_arns or lambda_pre_signup_secrets_manager_arns in the IAM module."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_name" {
  description = "Name of the secret in Secrets Manager"
  value       = aws_secretsmanager_secret.this.name
}

output "secret_id" {
  description = "ID of the secret (same as name)"
  value       = aws_secretsmanager_secret.this.id
}

output "secret_version_id" {
  description = "Version ID of the initial secret value"
  value       = aws_secretsmanager_secret_version.this.version_id
}
