output "api_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_endpoint" {
  description = "Base endpoint of the API Gateway"
  value       = aws_api_gateway_stage.stage.invoke_url
}

output "api_arn" {
  description = "ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.main.arn
}

output "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.main.execution_arn
}

output "stage_arn" {
  description = "ARN of the API Gateway stage"
  value       = aws_api_gateway_stage.stage.arn
}

output "vpc_link_id" {
  description = "ID of the VPC Link to the ALB"
  value       = aws_apigatewayv2_vpc_link.link_to_alb.id
}
