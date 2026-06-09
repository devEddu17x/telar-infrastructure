resource "aws_appautoscaling_target" "aurora_readers" {
  count = var.auto_scaling_enabled ? 1 : 0

  max_capacity       = var.auto_scaling_max_readers
  min_capacity       = var.auto_scaling_min_readers
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "aurora_cpu" {
  count = var.auto_scaling_enabled ? 1 : 0

  name               = "${var.name_prefix}-aurora-cpu-target"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.aurora_readers[0].resource_id
  scalable_dimension = aws_appautoscaling_target.aurora_readers[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.aurora_readers[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }
    target_value       = var.auto_scaling_cpu_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "aurora_connections" {
  count = var.auto_scaling_enabled ? 1 : 0

  name               = "${var.name_prefix}-aurora-connections-target"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.aurora_readers[0].resource_id
  scalable_dimension = aws_appautoscaling_target.aurora_readers[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.aurora_readers[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageDatabaseConnections"
    }
    target_value       = var.auto_scaling_connections_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
