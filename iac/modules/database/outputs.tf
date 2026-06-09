output "cluster_id" {
  description = "Identifier of the Aurora cluster"
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "ARN of the Aurora cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "Read-only endpoint for the Aurora cluster"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_port" {
  description = "Port on which the Aurora cluster accepts connections"
  value       = aws_rds_cluster.this.port
}

output "database_name" {
  description = "Name of the default database"
  value       = aws_rds_cluster.this.database_name
}

output "subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "auto_scaling_enabled" {
  description = "Whether Aurora Auto Scaling is enabled"
  value       = var.auto_scaling_enabled
}

output "auto_scaling_min_readers" {
  description = "Minimum number of read replicas when auto-scaling is enabled"
  value       = var.auto_scaling_enabled ? var.auto_scaling_min_readers : null
}

output "auto_scaling_max_readers" {
  description = "Maximum number of read replicas when auto-scaling is enabled"
  value       = var.auto_scaling_enabled ? var.auto_scaling_max_readers : null
}
