output "ecs_execution_role_arn" {
  description = "ARN del ECS Execution Role. Inyectar en 'execution_role_arn' de la task definition de ECS."
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_execution_role_name" {
  description = "Nombre del ECS Execution Role."
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_task_role_arn" {
  description = "ARN del ECS Task Role. Inyectar en 'task_role_arn' de la task definition de ECS."
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  description = "Nombre del ECS Task Role."
  value       = aws_iam_role.ecs_task_role.name
}

output "lambda_pre_signup_role_arn" {
  description = "ARN del Lambda Execution Role para el Pre Sign-up Trigger de Cognito. Usar en el recurso 'aws_lambda_function.role'."
  value       = aws_iam_role.lambda_pre_signup_role.arn
}

output "lambda_pre_signup_role_name" {
  description = "Nombre del Lambda Execution Role para el Pre Sign-up Trigger."
  value       = aws_iam_role.lambda_pre_signup_role.name
}
