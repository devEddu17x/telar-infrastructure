output "ecs_log_group_name" {
  description = "Name of the ECS API log group"
  value       = aws_cloudwatch_log_group.ecs_api.name
}

output "ecs_log_group_arn" {
  description = "ARN of the ECS API log group"
  value       = aws_cloudwatch_log_group.ecs_api.arn
}

output "api_gateway_access_log_group_name" {
  description = "Name of the API Gateway access log group"
  value       = aws_cloudwatch_log_group.api_gateway_access.name
}

output "api_gateway_access_log_group_arn" {
  description = "ARN of the API Gateway access log group"
  value       = aws_cloudwatch_log_group.api_gateway_access.arn
}
