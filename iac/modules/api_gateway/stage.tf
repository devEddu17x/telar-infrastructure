resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_resource.auth.id,
      aws_api_gateway_resource.auth_proxy.id,
      aws_api_gateway_method.proxy.id,
      aws_api_gateway_method.auth_proxy.id,
      aws_api_gateway_integration.proxy.id,
      aws_api_gateway_integration.auth_proxy.id,
      aws_api_gateway_authorizer.cognito.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.api_stage

  depends_on = [aws_api_gateway_account.main]

  access_log_settings {
    destination_arn = var.access_log_group_arn
    format = jsonencode({
      requestId          = "$context.requestId"
      ip                 = "$context.identity.sourceIp"
      requestTime        = "$context.requestTime"
      httpMethod         = "$context.httpMethod"
      routeKey           = "$context.routeKey"
      status             = "$context.status"
      protocol           = "$context.protocol"
      responseLength     = "$context.responseLength"
      integrationLatency = "$context.integrationLatency"
    })
  }

  tags = var.tags
}
