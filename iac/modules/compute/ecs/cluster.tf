resource "aws_ecs_cluster" "api" {
  name = "${var.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "ENABLED" : "DISABLED"
  }

  tags = var.tags
}
