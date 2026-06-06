resource "aws_apigatewayv2_route" "routes" {
  for_each = { for route in var.routes : route.route_key => route }

  api_id    = aws_apigatewayv2_api.main.id
  route_key = each.value.route_key
  target    = "integrations/${aws_apigatewayv2_integration.vpc_link_alb.id}"

  authorization_type = each.value.authorization_type
  authorizer_id      = each.value.authorization_type == "JWT" ? aws_apigatewayv2_authorizer.cognito.id : null
}
