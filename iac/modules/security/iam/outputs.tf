output "ecs_execution_role_arn" {
  description = "El ARN del Execution Role de ECS"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_execution_role_name" {
  description = "El nombre del Execution Role de ECS"
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_task_role_arn" {
  description = "El ARN del Task Role de ECS"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  description = "El nombre del Task Role de ECS"
  value       = aws_iam_role.ecs_task_role.name
}
