output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.auth.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = module.auth.user_pool_arn
}

output "cognito_user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = module.auth.user_pool_endpoint
}

output "cognito_frontend_client_id" {
  description = "Client ID of the User Pool Client for the frontend"
  value       = module.auth.frontend_client_id
}

output "firewall_api_web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL."
  value       = module.firewall_api.web_acl_arn
}

output "firewall_api_web_acl_id" {
  description = "ID of the WAFv2 Web ACL"
  value       = module.firewall_api.web_acl_id
}

output "firewall_api_web_acl_name" {
  description = "Name of the WAFv2 Web ACL"
  value       = module.firewall_api.web_acl_name
}

output "firewall_api_web_acl_capacity" {
  description = "Web ACL Capacity Units (WCU) consumed by the configured rules"
  value       = module.firewall_api.web_acl_capacity
}

output "ecs_execution_role_arn" {
  description = "ARN of the ECS Execution Role"
  value       = module.iam.ecs_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value       = module.iam.ecs_task_role_arn
}

output "lambda_pre_signup_role_arn" {
  description = "ARN of the Lambda Pre Sign-up Role"
  value       = module.iam.lambda_pre_signup_role_arn
}

output "ssm_parameter_arns" {
  description = "ARNs of the created SSM parameters"
  value       = module.ssm_parameters.parameter_arns
}

output "shared_secret_arn" {
  description = "ARN of the shared internal auth token secret"
  value       = module.shared_secrets.secret_arn
}
