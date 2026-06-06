resource "aws_apigatewayv2_integration" "vpc_link_alb" {
  api_id           = aws_apigatewayv2_api.main.id
  description      = "Integration Api Gateway to ALB by VPC Link"
  integration_type = "HTTP_PROXY"
  integration_uri  = var.alb_listener_arn

  integration_method   = "ANY"
  connection_type      = "VPC_LINK"
  timeout_milliseconds = 5000
  connection_id        = aws_apigatewayv2_vpc_link.link_to_alb.id
}
