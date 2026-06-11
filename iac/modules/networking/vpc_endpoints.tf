locals {
  endpoints = {
    "ecr-api" = {
      name = "ecr.api"
      type = "Interface"
    },
    "ecr-dkr" = {
      name = "ecr.dkr"
      type = "Interface"
    },
    "secretsmanager" = {
      name = "secretsmanager"
      type = "Interface"
    },
    "logs" = {
      name = "logs"
      type = "Interface"
    },
    "monitoring" = {
      name = "monitoring"
      type = "Interface"
    },
    "xray" = {
      name = "xray"
      type = "Interface"
    }
  }
}

resource "aws_vpc_endpoint" "interfaces" {
  for_each          = local.endpoints
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.${each.value.name}"
  vpc_endpoint_type = each.value.type
  subnet_ids        = [for subnet in aws_subnet.private_compute : subnet.id]
  security_group_ids = [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${each.key}-endpoint"
  })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [
    for rt in aws_route_table.private_compute : rt.id
  ]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-s3-endpoint"
  })
}