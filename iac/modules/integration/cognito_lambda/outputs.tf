output "lambda_permission_id" {
  description = "ID of the Lambda permission that allows Cognito to invoke the Pre Sign-up function"
  value       = aws_lambda_permission.allow_cognito.id
}
