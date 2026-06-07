resource "aws_ecs_task_definition" "api" {
  family                   = "${var.name_prefix}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.name_prefix}-api-container"
      image     = var.container_image
      essential = true
      cpu       = tonumber(var.task_cpu)
      memory    = tonumber(var.task_memory)

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = var.environment_variables
      secrets     = var.secrets

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${var.name_prefix}-api-logs"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "${var.name_prefix}-ecs-api-logs"
        }
      }
    }
  ])

  tags = var.tags
}
