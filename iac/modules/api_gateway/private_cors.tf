resource "aws_api_gateway_method" "auth_proxy_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.auth_proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "auth_proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.auth_proxy.id
  http_method = aws_api_gateway_method.auth_proxy_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "auth_proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.auth_proxy.id
  http_method = aws_api_gateway_method.auth_proxy_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Access-Control-Max-Age"           = true
    "method.response.header.Access-Control-Expose-Headers"    = true
  }
}

resource "aws_api_gateway_integration_response" "auth_proxy_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.auth_proxy.id
  http_method = aws_api_gateway_method.auth_proxy_options.http_method
  status_code = aws_api_gateway_method_response.auth_proxy_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'${join(",", var.cors_configuration.allow_headers)}'"
    "method.response.header.Access-Control-Allow-Methods"     = "'${join(",", var.cors_configuration.allow_methods)}'"
    "method.response.header.Access-Control-Allow-Origin"      = "'${join(",", var.cors_configuration.allow_origins)}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'${tostring(var.cors_configuration.allow_credentials)}'"
    "method.response.header.Access-Control-Max-Age"           = "'${tostring(var.cors_configuration.max_age)}'"
    "method.response.header.Access-Control-Expose-Headers"    = "'${join(",", var.cors_configuration.expose_headers)}'"
  }

  response_templates = {
    "application/json" = ""
  }
}
