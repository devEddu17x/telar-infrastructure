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

output "master_username" {
  description = "Master username for the cluster"
  value       = aws_rds_cluster.this.master_username
}

output "master_secret_arn" {
  description = "ARN of the master user secret managed by RDS"
  value       = aws_rds_cluster.this.master_user_secret[0].secret_arn
}

output "backup_plan_id" {
  description = "ID of the AWS Backup plan protecting the Aurora cluster"
  value       = aws_backup_plan.this.id
}

output "backup_vault_name" {
  description = "Name of the AWS Backup vault where recovery points are stored"
  value       = aws_backup_vault.this.name
}
