resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = true
  drop_invalid_header_fields = true


  access_logs {
    enabled = true
    bucket  = var.access_logs_bucket_id
    prefix  = var.access_logs_prefix
  }

  tags = var.tags
}
