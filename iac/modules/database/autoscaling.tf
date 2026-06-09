resource "terraform_data" "validate_auto_scaling" {
  lifecycle {
    precondition {
      condition     = var.auto_scaling_min_readers <= var.auto_scaling_max_readers
      error_message = "auto_scaling_min_readers must be less than or equal to auto_scaling_max_readers."
    }
  }
}

module "auto_scaling_cpu" {
  count  = var.auto_scaling_enabled ? 1 : 0
  source = "../compute/auto_scaling"

  namespace   = "rds"
  dimension   = "rds:cluster:ReadReplicaCount"
  resource    = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  metric_type = "RDSReaderAverageCPUUtilization"
  min         = var.auto_scaling_min_readers
  max         = var.auto_scaling_max_readers
  target      = var.auto_scaling_cpu_target
}

resource "aws_appautoscaling_policy" "aurora_connections" {
  count = var.auto_scaling_enabled ? 1 : 0

  depends_on = [module.auto_scaling_cpu]

  name               = "${var.name_prefix}-aurora-connections-target"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageDatabaseConnections"
    }
    target_value       = var.auto_scaling_connections_target
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
