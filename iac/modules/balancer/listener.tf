resource "aws_lb_listener" "alb_listener" {
  #checkov:skip=CKV_AWS_2:ALB esta en una red privada
  #checkov:skip=CKV2_AWS_20:No es necesario redirigir a https
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb.port
  protocol          = var.alb.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
