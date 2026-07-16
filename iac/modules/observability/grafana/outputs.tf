output "workspace_id" {
  description = "Grafana workspace ID"
  value       = aws_grafana_workspace.this.id
}

output "workspace_arn" {
  description = "Grafana workspace ARN"
  value       = aws_grafana_workspace.this.arn
}

output "workspace_endpoint" {
  description = "Grafana workspace endpoint"
  value       = aws_grafana_workspace.this.endpoint
}

output "workspace_name" {
  description = "Grafana workspace name"
  value       = aws_grafana_workspace.this.name
}
