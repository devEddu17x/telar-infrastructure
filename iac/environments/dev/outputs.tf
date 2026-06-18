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
  description = "ARN of the WAFv2 Web ACL for the API"
  value       = module.firewall_api.web_acl_arn
}

output "firewall_api_web_acl_id" {
  description = "ID of the WAFv2 Web ACL for the API"
  value       = module.firewall_api.web_acl_id
}

output "firewall_api_web_acl_name" {
  description = "Name of the WAFv2 Web ACL for the API"
  value       = module.firewall_api.web_acl_name
}

output "firewall_api_web_acl_capacity" {
  description = "Web ACL Capacity Units (WCU) consumed by the API WAF"
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

output "balancer_alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.balancer.alb_arn
}

output "balancer_alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = module.balancer.alb_listener_arn
}

output "balancer_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.balancer.target_group_arn
}

output "balancer_alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.balancer.alb_dns_name
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = module.api_gateway.api_id
}

output "api_gateway_endpoint" {
  description = "Base endpoint of the API Gateway"
  value       = module.api_gateway.api_endpoint
}

output "api_gateway_stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = module.api_gateway.stage_arn
}

output "api_gateway_vpc_link_id" {
  description = "ID of the VPC Link"
  value       = module.api_gateway.vpc_link_id
}

output "frontend_system_app_id" {
  description = "Amplify app ID for the system frontend"
  value       = module.frontend_system.app_id
}

output "frontend_system_branch_url" {
  description = "Public HTTPS URL for the deployed system frontend branch"
  value       = module.frontend_system.branch_url
}

output "frontend_system_default_domain" {
  description = "Default Amplify domain for the system frontend"
  value       = module.frontend_system.default_domain
}
