resource "aws_rds_cluster" "this" {
  cluster_identifier          = "${var.name_prefix}-aurora-cluster"
  engine                      = "aurora-postgresql"
  engine_version              = var.engine_version
  database_name               = var.database_name
  master_username             = var.master_username
  manage_master_user_password = true
  enable_http_endpoint        = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  serverlessv2_scaling_configuration {
    min_capacity = var.serverless_min_capacity
    max_capacity = var.serverless_max_capacity
  }

  storage_encrypted = true

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  deletion_protection             = var.deletion_protection
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.name_prefix}-aurora-final-snapshot"
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = var.tags

  lifecycle {
    ignore_changes = [availability_zones]
  }
}
