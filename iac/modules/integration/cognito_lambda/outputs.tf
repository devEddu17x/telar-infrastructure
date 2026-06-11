output "lambda_config_id" {
  description = "ID of the Cognito User Pool Lambda Config"
  value       = aws_cognito_user_pool_lambda_config.pre_signup.id
}
