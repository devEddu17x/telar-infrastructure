resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for the ALB"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from VPC"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from VPC"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id = aws_security_group.alb.id

  description                  = "Allow traffic to ECS tasks on container port"
  from_port                    = var.ecs_container_port
  to_port                      = var.ecs_container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_tasks.id
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}-ecs-tasks-sg"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs_tasks.id

  description                  = "Allow traffic from ALB on container port"
  from_port                    = var.ecs_container_port
  to_port                      = var.ecs_container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_to_endpoints" {
  security_group_id = aws_security_group.ecs_tasks.id

  description                  = "Allow HTTPS to VPC endpoints"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.vpc_endpoints.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_to_aurora" {
  security_group_id = aws_security_group.ecs_tasks.id

  description                  = "Allow PostgreSQL to Aurora"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.aurora.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_to_s3" {
  security_group_id = aws_security_group.ecs_tasks.id

  description    = "Allow HTTPS to S3 via gateway endpoint for ECR image layers"
  from_port      = 443
  to_port        = 443
  ip_protocol    = "tcp"
  prefix_list_id = aws_vpc_endpoint.s3.prefix_list_id
}

resource "aws_security_group" "apigw_vpc_link" {
  name        = "${var.name_prefix}-apigw-vpc-link-sg"
  description = "Security group for API Gateway VPC Link to ALB"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "apigw_http" {
  security_group_id = aws_security_group.apigw_vpc_link.id

  description = "Allow API Gateway to connect on HTTP"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr
}

resource "aws_vpc_security_group_ingress_rule" "apigw_https" {
  security_group_id = aws_security_group.apigw_vpc_link.id

  description = "Allow API Gateway to connect on HTTPS"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr
}

resource "aws_vpc_security_group_egress_rule" "apigw_to_alb_http" {
  security_group_id = aws_security_group.apigw_vpc_link.id

  description                  = "Allow VPC Link to reach ALB on HTTP"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "apigw_to_alb_https" {
  security_group_id = aws_security_group.apigw_vpc_link.id

  description                  = "Allow VPC Link to reach ALB on HTTPS"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "aurora" {
  name        = "${var.name_prefix}-aurora-sg"
  description = "Security group for Aurora cluster"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "aurora_from_ecs" {
  security_group_id = aws_security_group.aurora.id

  description                  = "Allow PostgreSQL from ECS tasks"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs_tasks.id
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.name_prefix}-vpc-endpoints-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "endpoints_https" {
  security_group_id = aws_security_group.vpc_endpoints.id

  description = "Allow HTTPS from VPC"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.vpc_cidr
}
