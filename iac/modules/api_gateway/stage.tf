resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy.id,
      aws_api_gateway_resource.auth.id,
      aws_api_gateway_resource.auth_proxy.id,
      var.cors_configuration,
      aws_api_gateway_method.proxy.id,
      aws_api_gateway_method.auth_proxy.id,
      aws_api_gateway_method.proxy.request_parameters,
      aws_api_gateway_method.auth_proxy.request_parameters,
      aws_api_gateway_method.docs_proxy.request_parameters,
      aws_api_gateway_integration.proxy.id,
      aws_api_gateway_integration.auth_proxy.id,
      aws_api_gateway_integration.proxy.request_parameters,
      aws_api_gateway_integration.auth_proxy.request_parameters,
      aws_api_gateway_integration.docs_proxy.request_parameters,
      aws_api_gateway_integration.proxy.uri,
      aws_api_gateway_integration.auth_proxy.uri,
      aws_api_gateway_integration.docs_proxy.uri,
      aws_api_gateway_integration.health.uri,
      aws_api_gateway_integration.docs.uri,
      aws_api_gateway_integration.docs_json.uri,
      aws_api_gateway_authorizer.cognito.id,
      aws_api_gateway_resource.api.id,
      aws_api_gateway_resource.v1.id,
      aws_api_gateway_resource.health.id,
      aws_api_gateway_resource.docs.id,
      aws_api_gateway_resource.docs_json.id,
      aws_api_gateway_resource.docs_proxy.id,
      aws_api_gateway_method.health.id,
      aws_api_gateway_method.docs.id,
      aws_api_gateway_method.docs_json.id,
      aws_api_gateway_method.docs_proxy.id,
      aws_api_gateway_integration.health.id,
      aws_api_gateway_integration.docs.id,
      aws_api_gateway_integration.docs_json.id,
      aws_api_gateway_integration.docs_proxy.id,
      aws_api_gateway_method.health_options.id,
      aws_api_gateway_method.docs_options.id,
      aws_api_gateway_method.docs_json_options.id,
      aws_api_gateway_integration.health_options.id,
      aws_api_gateway_integration.docs_options.id,
      aws_api_gateway_integration.docs_json_options.id,
      aws_api_gateway_method_response.health_options.id,
      aws_api_gateway_method_response.docs_options.id,
      aws_api_gateway_method_response.docs_json_options.id,
      aws_api_gateway_integration_response.health_options.id,
      aws_api_gateway_integration_response.docs_options.id,
      aws_api_gateway_integration_response.docs_json_options.id,
      aws_api_gateway_method.auth_proxy_options.id,
      aws_api_gateway_integration.auth_proxy_options.id,
      aws_api_gateway_method_response.auth_proxy_options.id,
      aws_api_gateway_integration_response.auth_proxy_options.id,
      aws_api_gateway_method.proxy_options.id,
      aws_api_gateway_integration.proxy_options.id,
      aws_api_gateway_method_response.proxy_options.id,
      aws_api_gateway_integration_response.proxy_options.id,
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

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.stage.stage_name
  method_path = "*/*"

  settings {
    logging_level   = "INFO"
    metrics_enabled = true
  }
}
