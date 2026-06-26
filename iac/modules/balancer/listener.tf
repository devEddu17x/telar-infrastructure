resource "aws_lb_listener" "alb_listener" {
  #checkov:skip=CKV_AWS_2:The ALB uses HTTP because it is in a VPC and connects to the API through a vpclink
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb.port
  protocol          = var.alb.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
