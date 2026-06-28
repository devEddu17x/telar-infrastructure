resource "aws_api_gateway_rest_api" "main" {
  name = "${var.name_prefix}-api"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
