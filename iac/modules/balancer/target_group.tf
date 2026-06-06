resource "aws_lb_target_group" "tg" {
  name     = "${var.name_prefix}-tg"
  port     = var.target_group.port
  protocol = var.target_group.protocol
  vpc_id   = var.vpc_id

  target_type          = var.target_group.target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    enabled             = var.health_check.enabled
    path                = var.health_check.path
    protocol            = var.health_check.protocol
    port                = var.health_check.port
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    matcher             = var.health_check.matcher
  }

  tags = var.tags
}
