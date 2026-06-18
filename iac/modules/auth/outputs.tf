output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.arn
}

output "user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.endpoint
}

output "frontend_client_id" {
  description = "Client ID of the User Pool Client for the frontend"
  value       = aws_cognito_user_pool_client.frontend_client.id
}

output "user_pool_issuer_url" {
  description = "Issuer URL of the Cognito User Pool"
  value       = "https://cognito-idp.${data.aws_region.current.region}.amazonaws.com/${aws_cognito_user_pool.pool.id}"
}
