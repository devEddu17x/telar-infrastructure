resource "aws_api_gateway_resource" "api" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = var.api_prefix
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = var.api_version
}

resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "health"
}

resource "aws_api_gateway_method" "health" {
  #checkov:skip=CKV_AWS_59:Health endpoint must stay public for API availability checks.

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.health.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "health" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.health.id
  http_method             = aws_api_gateway_method.health.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.alb_dns_name}/${var.api_prefix}/${var.api_version}/health"
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.link_to_alb.id
  integration_target      = var.alb_arn
}

resource "aws_api_gateway_resource" "docs" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "docs"
}

resource "aws_api_gateway_method" "docs" {
  #checkov:skip=CKV_AWS_59:Swagger documentation must stay public for frontend development.

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.docs.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "docs" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.docs.id
  http_method             = aws_api_gateway_method.docs.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.alb_dns_name}/${var.api_prefix}/${var.api_version}/docs"
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.link_to_alb.id
  integration_target      = var.alb_arn
}

resource "aws_api_gateway_resource" "docs_proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.docs.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "docs_proxy" {
  #checkov:skip=CKV_AWS_59:Swagger assets must stay public to load documentation resources.

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.docs_proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "docs_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.docs_proxy.id
  http_method             = aws_api_gateway_method.docs_proxy.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.alb_dns_name}/${var.api_prefix}/${var.api_version}/docs/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.link_to_alb.id
  integration_target      = var.alb_arn

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_resource" "docs_json" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "docs-json"
}

resource "aws_api_gateway_method" "docs_json" {
  #checkov:skip=CKV_AWS_59:Swagger JSON must stay public for frontend endpoint discovery.

  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.docs_json.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "docs_json" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.docs_json.id
  http_method             = aws_api_gateway_method.docs_json.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.alb_dns_name}/${var.api_prefix}/${var.api_version}/docs-json"
  connection_type         = "VPC_LINK"
  connection_id           = aws_apigatewayv2_vpc_link.link_to_alb.id
  integration_target      = var.alb_arn
}
