output "api_id" {
  description = "API Gateway ID"
  value       = aws_apigatewayv2_api.main.id
}

output "api_endpoint" {
  description = "Base endpoint of the API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_arn" {
  description = "ARN of the API Gateway"
  value       = aws_apigatewayv2_api.main.arn
}

output "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.main.execution_arn
}

output "stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = aws_apigatewayv2_stage.stage.arn
}

output "vpc_link_id" {
  description = "ID of the VPC Link to the ALB"
  value       = aws_apigatewayv2_vpc_link.link_to_alb.id
}
