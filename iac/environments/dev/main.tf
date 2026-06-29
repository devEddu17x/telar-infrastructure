module "networking" {
  source                   = "../../modules/networking"
  region                   = var.aws_region
  name_prefix              = local.name_prefix
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  compute_subnet_cidrs     = var.compute_subnet_cidrs
  persistence_subnet_cidrs = var.persistence_subnet_cidrs
  ecs_container_port       = var.ecs_container_port
  tags                     = local.default_tags
}

module "auth" {
  source            = "../../modules/auth"
  name_prefix       = local.name_prefix
  app_email_subject = var.project_name
}

module "storage_images" {
  source               = "../../modules/storage"
  name_prefix          = local.name_prefix
  bucket_suffix        = "images"
  force_destroy        = var.s3_images_force_destroy
  cors                 = var.s3_images_cors
  manage_bucket_policy = false
  tags                 = local.default_tags
}

module "ecr_api" {
  source          = "../../modules/repository"
  repository_name = "${local.name_prefix}-api"
  force_delete    = var.ecr_force_delete
  tags            = local.default_tags
}

module "firewall_api" {
  source                     = "../../modules/firewall"
  name_prefix                = local.name_prefix
  scope                      = "REGIONAL"
  rate_limits                = var.firewall_rate_limits
  cloudwatch_metrics_enabled = var.firewall_cloudwatch_metrics_enabled
  sampled_requests_enabled   = var.firewall_sampled_requests_enabled
  log_destination_arns       = var.firewall_log_destination_arns
  logging_redacted_fields    = var.firewall_redacted_fields
  tags                       = local.default_tags
}

module "observability" {
  source      = "../../modules/observability"
  name_prefix = local.name_prefix
  tags        = local.default_tags
}


module "ssm_parameters" {
  source      = "../../modules/security/ssm_parameters"
  name_prefix = local.name_prefix
  parameters = merge(
    var.backend_env,
    {
      IMAGES_BUCKET_NAME                 = module.storage_images.bucket_name
      IMAGES_BUCKET_REGION               = var.aws_region
      IMAGES_BUCKET_REGIONAL_DOMAIN_NAME = module.storage_images.bucket_regional_domain_name
    }
  )
  tags = local.default_tags
}

module "shared_secrets" {
  source                  = "../../modules/security/secrets_manager"
  secret_name             = "${local.name_prefix}/backend/internal-auth-token"
  description             = "Internal auth token for backend-to-Cognito operations"
  secret_string           = var.cognito_internal_auth_token.value
  recovery_window_in_days = var.cognito_internal_auth_token.retention_days
  tags                    = local.default_tags
}

module "iam" {
  source                                 = "../../modules/security/iam"
  name_prefix                            = local.name_prefix
  s3_bucket_arns                         = [module.storage_images.bucket_arn]
  cognito_user_pool_arn                  = module.auth.user_pool_arn
  ecs_execution_secrets_manager_arns     = [module.shared_secrets.secret_arn]
  lambda_pre_signup_secrets_manager_arns = [module.shared_secrets.secret_arn]
  ssm_parameter_arns                     = module.ssm_parameters.parameter_arns
}

module "database" {
  source                       = "../../modules/database"
  name_prefix                  = local.name_prefix
  availability_zones           = var.availability_zones
  subnet_ids                   = module.networking.private_persistence_subnet_ids
  security_group_ids           = module.networking.aurora_security_group_id
  engine_version               = var.db_engine_version
  database_name                = var.db_name
  master_username              = var.db_master_username
  serverless_min_capacity      = var.db_min_capacity
  serverless_max_capacity      = var.db_max_capacity
  backup_retention_period      = var.db_backup_retention_period
  preferred_backup_window      = var.db_backup_window
  preferred_maintenance_window = var.db_maintenance_window
  deletion_protection          = var.db_deletion_protection
  skip_final_snapshot          = var.db_skip_final_snapshot
  monitoring_interval          = var.db_monitoring_interval
  monitoring_role_arn          = var.db_monitoring_interval > 0 ? module.iam.rds_monitoring_role_arn : null
  backup_iam_role_arn          = module.iam.backup_role_arn
  backup_schedule              = var.db_backup_schedule
  backup_retention_days        = var.db_backup_vault_retention_days
  backup_vault_force_destroy   = var.db_backup_vault_force_destroy
}

module "storage_balancer_logs" {
  source                  = "../../modules/storage"
  name_prefix             = local.name_prefix
  bucket_suffix           = "alb-logs"
  force_destroy           = var.balancer_logs_force_destroy
  cors                    = { enabled = false, allowed_origins = [] }
  alb_access_logs_enabled = true
  alb_access_logs_prefix  = "logs"
  tags                    = local.default_tags

  lifecycle_logs_enabled         = true
  lifecycle_logs_expiration_days = 14
}

module "balancer" {
  source                = "../../modules/balancer"
  name_prefix           = local.name_prefix
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.private_compute_subnet_ids
  security_group_ids    = [module.networking.alb_security_group_id]
  access_logs_bucket_id = module.storage_balancer_logs.bucket_id
  access_logs_prefix    = "logs"
  deletion_protection   = var.balancer_deletion_protection
  deregistration_delay  = var.balancer_deregistration_delay
  health_check          = var.balancer_health_check
  alb                   = var.balancer_alb
  target_group          = var.balancer_target_group
  tags                  = local.default_tags

  depends_on = [module.storage_balancer_logs]
}

module "api_gateway" {
  source                          = "../../modules/api_gateway"
  name_prefix                     = local.name_prefix
  api_stage                       = var.api_stage
  api_prefix                      = var.api_prefix
  api_version                     = var.api_version
  cognito_user_pool_arn           = module.auth.user_pool_arn
  alb_arn                         = module.balancer.alb_arn
  alb_dns_name                    = module.balancer.alb_dns_name
  private_subnet_ids              = module.networking.private_compute_subnet_ids
  apg_vpc_link_security_group_ids = [module.networking.apigw_vpc_link_security_group_id]
  waf_web_acl_arn                 = module.firewall_api.web_acl_arn
  access_log_group_arn            = module.observability.api_gateway_access_log_group_arn
  api_gateway_cloudwatch_role_arn = module.iam.api_gateway_cloudwatch_role_arn
  cors_configuration = merge(var.api_cors_configuration, {
    allow_origins = distinct(concat(
      var.api_cors_configuration.allow_origins,
      [
        "https://${module.cdn_frontend_system.distribution_domain_name}",
        "https://${module.cdn_landing_page.distribution_domain_name}"
      ]
    ))
  })
  tags = local.default_tags
}

resource "null_resource" "push_placeholder_image" {
  depends_on = [module.ecr_api]

  triggers = {
    repository_url = module.ecr_api.repository_url
    repository_arn = module.ecr_api.repository_arn
  }

  provisioner "local-exec" {
    command = <<-EOT
      set -e
      AWS_PAGER="" aws ecr get-login-password --region ${var.aws_region}${var.aws_profile != null ? " --profile ${var.aws_profile}" : ""} | \
        docker login --username AWS --password-stdin ${module.ecr_api.repository_url} > /dev/null 2>&1
      docker build --quiet -t ${module.ecr_api.repository_url}:placeholder ${path.module}/../../services/placeholder/
      docker push --quiet ${module.ecr_api.repository_url}:placeholder
    EOT
  }
}

module "cdn_images" {
  source = "../../modules/cdn/assets"

  name_prefix                 = "${local.name_prefix}-images"
  bucket_regional_domain_name = module.storage_images.bucket_regional_domain_name
  price_class                 = var.images_static.price_class
  enabled                     = var.images_static.enabled
  tags                        = local.default_tags
}

module "images_bucket_policy" {
  source = "../../modules/integration/cloudfront_s3_policy"

  bucket_id        = module.storage_images.bucket_id
  bucket_arn       = module.storage_images.bucket_arn
  distribution_arn = module.cdn_images.distribution_arn
}

module "ecs" {
  source               = "../../modules/compute/ecs"
  name_prefix          = local.name_prefix
  container_image      = coalesce(var.ecs_container_image, "${module.ecr_api.repository_url}:placeholder")
  container_port       = var.ecs_container_port
  desired_count        = var.ecs_desired_count
  task_cpu             = var.ecs_task_cpu
  task_memory          = var.ecs_task_memory
  subnet_ids           = module.networking.private_compute_subnet_ids
  security_group_ids   = [module.networking.ecs_tasks_security_group_id]
  alb_target_group_arn = module.balancer.target_group_arn
  execution_role_arn   = module.iam.ecs_execution_role_arn
  task_role_arn        = module.iam.ecs_task_role_arn
  aws_region           = var.aws_region
  log_group_name       = module.observability.ecs_log_group_name

  container_health_check = {
    path = "/${var.api_prefix}/${var.api_version}/health"
  }

  environment_variables = concat(
    [for k, v in var.backend_env : { name = k, value = v }],
    [
      { name = "DB_HOST", value = module.database.cluster_endpoint },
      { name = "DB_PORT", value = tostring(module.database.cluster_port) },
      { name = "DB_NAME", value = module.database.database_name },
      { name = "DB_USERNAME", value = module.database.master_username },
      { name = "API_STAGE", value = var.api_stage },
      { name = "AWS_COGNITO_USER_POOL_ID", value = module.auth.user_pool_id },
      { name = "AWS_COGNITO_CLIENT_ID", value = module.auth.frontend_client_id },
      { name = "STORAGE_BUCKET_NAME", value = module.storage_images.bucket_name },
      { name = "STORAGE_REGION", value = var.aws_region },
      { name = "STORAGE_PUBLIC_URL", value = "https://${module.cdn_images.distribution_domain_name}" },
    ]
  )

  secrets = [
    {
      name      = "DB_CREDENTIALS"
      valueFrom = module.database.master_secret_arn
    },
    {
      name      = "AWS_COGNITO_INTERNAL_AUTH_TOKEN"
      valueFrom = module.shared_secrets.secret_arn
    }
  ]

  tags       = local.default_tags
  depends_on = [null_resource.push_placeholder_image]
}

module "backend_deploy_parameters" {
  source = "../../modules/security/ssm_parameters"

  name_prefix = "${local.name_prefix}/backend/deploy"
  parameters = {
    AWS_REGION              = var.aws_region
    ECR_REPOSITORY_NAME     = module.ecr_api.repository_name
    ECR_REPOSITORY_URL      = module.ecr_api.repository_url
    ECS_CLUSTER_NAME        = module.ecs.cluster_name
    ECS_SERVICE_NAME        = module.ecs.service_name
    ECS_TASK_DEFINITION_ARN = module.ecs.task_definition_arn
  }
  tags = local.default_tags
}

module "auto_scaling" {
  source      = "../../modules/compute/auto_scaling"
  resource    = "service/${module.ecs.cluster_name}/${module.ecs.service_name}"
  min         = var.ecs_auto_scaling.min
  max         = var.ecs_auto_scaling.max
  target      = var.ecs_auto_scaling.target
  metric_type = var.ecs_auto_scaling.metric_type
}

module "storage_frontend_system" {
  source = "../../modules/storage"

  name_prefix          = local.name_prefix
  bucket_suffix        = "system-frontend"
  force_destroy        = var.frontend_system_static.force_destroy
  cors                 = { enabled = false, allowed_origins = [] }
  manage_bucket_policy = false
  tags                 = local.default_tags
}

module "cdn_frontend_system" {
  source = "../../modules/cdn/static_site"

  name_prefix                 = "${local.name_prefix}-system-frontend"
  bucket_regional_domain_name = module.storage_frontend_system.bucket_regional_domain_name
  price_class                 = var.frontend_system_static.price_class
  enabled                     = var.frontend_system_static.enabled
  default_root_object         = "index.html"
  tags                        = local.default_tags
}

module "frontend_system_bucket_policy" {
  source = "../../modules/integration/cloudfront_s3_policy"

  bucket_id        = module.storage_frontend_system.bucket_id
  bucket_arn       = module.storage_frontend_system.bucket_arn
  distribution_arn = module.cdn_frontend_system.distribution_arn
}

module "frontend_system_parameters" {
  source = "../../modules/security/ssm_parameters"

  name_prefix = "${local.name_prefix}/frontend"
  parameters = {
    NEXT_PUBLIC_API_URL               = "${module.api_gateway.api_endpoint}/${var.api_prefix}/${var.api_version}"
    NEXT_PUBLIC_AWS_COGNITO_REGION    = var.aws_region
    NEXT_PUBLIC_AWS_COGNITO_CLIENT_ID = module.auth.frontend_client_id
    ASSETS_HOSTNAME                   = module.cdn_images.distribution_domain_name
    FRONTEND_BUCKET_NAME              = module.storage_frontend_system.bucket_name
    FRONTEND_DISTRIBUTION_ID          = module.cdn_frontend_system.distribution_id
  }
  tags = local.default_tags
}

module "storage_landing_page" {
  source = "../../modules/storage"

  name_prefix          = local.name_prefix
  bucket_suffix        = "landing-page"
  force_destroy        = var.landing_page_static.force_destroy
  cors                 = { enabled = false, allowed_origins = [] }
  manage_bucket_policy = false
  tags                 = local.default_tags
}

module "cdn_landing_page" {
  source = "../../modules/cdn/static_site"

  name_prefix                 = "${local.name_prefix}-landing-page"
  bucket_regional_domain_name = module.storage_landing_page.bucket_regional_domain_name
  price_class                 = var.landing_page_static.price_class
  enabled                     = var.landing_page_static.enabled
  default_root_object         = "index.html"
  tags                        = local.default_tags
}

module "landing_page_bucket_policy" {
  source = "../../modules/integration/cloudfront_s3_policy"

  bucket_id        = module.storage_landing_page.bucket_id
  bucket_arn       = module.storage_landing_page.bucket_arn
  distribution_arn = module.cdn_landing_page.distribution_arn
}

module "landing_page_parameters" {
  source = "../../modules/security/ssm_parameters"

  name_prefix = "${local.name_prefix}/landing-page"
  parameters = {
    NEXT_PUBLIC_REDIRECT_URL = "https://${module.cdn_frontend_system.distribution_domain_name}"
    LANDING_BUCKET_NAME      = module.storage_landing_page.bucket_name
    LANDING_DISTRIBUTION_ID  = module.cdn_landing_page.distribution_id
  }
  tags = local.default_tags
}
