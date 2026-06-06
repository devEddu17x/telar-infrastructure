resource "aws_apigatewayv2_vpc_link" "link_to_alb" {
  name               = "${var.name_prefix}-vpc-link-to-alb"
  security_group_ids = var.apg_vpc_link_security_group_ids
  subnet_ids         = var.private_subnet_ids

  tags = var.tags
}
