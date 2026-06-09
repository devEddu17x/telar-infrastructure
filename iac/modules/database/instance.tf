resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.name_prefix}-aurora-writer"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_subnet_group_name    = aws_db_subnet_group.this.name
  db_parameter_group_name = aws_rds_cluster_parameter_group.this.name

  availability_zone          = var.availability_zones[0]
  publicly_accessible        = false
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  tags = merge(var.tags, { Role = "writer" })
}

resource "aws_rds_cluster_instance" "readers" {
  count = var.auto_scaling_enabled ? var.auto_scaling_min_readers : var.reader_count

  identifier         = "${var.name_prefix}-aurora-reader-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_subnet_group_name    = aws_db_subnet_group.this.name
  db_parameter_group_name = aws_rds_cluster_parameter_group.this.name

  # Distribute readers across AZs
  availability_zone          = var.availability_zones[count.index % length(var.availability_zones)]
  publicly_accessible        = false
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  tags = merge(var.tags, { Role = "reader", Index = tostring(count.index + 1) })
}
