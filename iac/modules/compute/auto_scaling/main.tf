resource "aws_appautoscaling_target" "this" {
  service_namespace  = var.namespace
  resource_id        = var.resource
  scalable_dimension = var.dimension
  min_capacity       = var.min
  max_capacity       = var.max
}

resource "aws_appautoscaling_policy" "this" {
  name               = replace(var.resource, "/", "-")
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.metric_type
    }
    target_value = var.target
  }
}
