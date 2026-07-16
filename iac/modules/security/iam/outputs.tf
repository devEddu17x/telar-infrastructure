output "ecs_execution_role_arn" {
  description = "ARN of the ECS Execution Role. Inject into 'execution_role_arn' of the ECS task definition."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_execution_role_name" {
  description = "Name of the ECS Execution Role."
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role. Inject into 'task_role_arn' of the ECS task definition."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  description = "Name of the ECS Task Role."
  value       = aws_iam_role.ecs_task_role.name
}

output "lambda_pre_signup_role_arn" {
  description = "ARN of the Lambda Execution Role for the Cognito Pre Sign-up Trigger. Use in 'aws_lambda_function.role'."
  value       = aws_iam_role.lambda_pre_signup_role.arn
}

output "lambda_pre_signup_role_name" {
  description = "Name of the Lambda Execution Role for the Pre Sign-up Trigger."
  value       = aws_iam_role.lambda_pre_signup_role.name
}

output "api_gateway_cloudwatch_role_arn" {
  description = "ARN of the IAM role used by API Gateway to write CloudWatch Logs"
  value       = aws_iam_role.api_gateway_cloudwatch.arn
}

output "rds_monitoring_role_arn" {
  description = "ARN of the IAM role used by RDS Enhanced Monitoring"
  value       = aws_iam_role.rds_monitoring.arn
}

output "backup_role_arn" {
  description = "ARN of the IAM role used by AWS Backup to protect RDS clusters (satisfies CKV2_AWS_8)"
  value       = aws_iam_role.backup.arn
}

output "grafana_role_arn" {
  description = "ARN of the IAM role used by Amazon Managed Grafana"
  value       = aws_iam_role.grafana.arn
}
