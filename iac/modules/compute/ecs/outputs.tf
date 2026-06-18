output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.api.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.api.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.nest_api.name
}

output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.nest_api.id
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.api.arn
}
