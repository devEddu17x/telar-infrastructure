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
  source             = "../../modules/storage"
  name_prefix        = local.name_prefix
  bucket_suffix      = "images"
  force_destroy      = var.s3_images_force_destroy
  cors               = var.s3_images_cors
  versioning_enabled = var.s3_images_versioning_enabled
  tags               = local.default_tags
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
  source            = "../../modules/observability"
  name_prefix       = local.name_prefix
  retention_in_days = var.observability_retention_in_days
  tags              = local.default_tags
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
}

module "ssm_parameters" {
  source      = "../../modules/security/ssm_parameters"
  name_prefix = local.name_prefix
  parameters = merge(
    var.backend_env,
    {
      IMAGES_BUCKET_NAME   = module.storage_images.bucket_name
      IMAGES_BUCKET_REGION = var.aws_region
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
  ecs_execution_secrets_manager_arns     = [module.database.master_secret_arn, module.shared_secrets.secret_arn]
  lambda_pre_signup_secrets_manager_arns = [module.shared_secrets.secret_arn]
  ssm_parameter_arns                     = module.ssm_parameters.parameter_arns
}

module "storage_balancer_logs" {
  source                  = "../../modules/storage"
  name_prefix             = local.name_prefix
  bucket_suffix           = "alb-logs"
  force_destroy           = var.s3_images_force_destroy
  versioning_enabled      = false
  cors                    = { enabled = false, allowed_origins = [] }
  alb_access_logs_enabled = true
  alb_access_logs_prefix  = "logs"
  tags                    = local.default_tags
}

module "balancer" {
  source                     = "../../modules/balancer"
  name_prefix                = local.name_prefix
  vpc_id                     = module.networking.vpc_id
  subnet_ids                 = module.networking.private_compute_subnet_ids
  security_group_ids         = [module.networking.alb_security_group_id]
  access_logs_bucket_id      = module.storage_balancer_logs.bucket_id
  access_logs_prefix         = "logs"
  deregistration_delay       = var.balancer_deregistration_delay
  health_check               = var.balancer_health_check
  alb                        = var.balancer_alb
  target_group               = var.balancer_target_group
  tags                       = local.default_tags

  depends_on = [module.storage_balancer_logs]
}

module "api_gateway" {
  source                          = "../../modules/api_gateway"
  name_prefix                     = local.name_prefix
  api_stage                       = var.api_stage
  cognito_user_pool_arn           = module.auth.user_pool_arn
  alb_arn                         = module.balancer.alb_arn
  alb_dns_name                    = module.balancer.alb_dns_name
  private_subnet_ids              = module.networking.private_compute_subnet_ids
  apg_vpc_link_security_group_ids = [module.networking.apigw_vpc_link_security_group_id]
  waf_web_acl_arn                 = module.firewall_api.web_acl_arn
  access_log_group_arn            = module.observability.api_gateway_access_log_group_arn
  api_gateway_cloudwatch_role_arn = module.iam.api_gateway_cloudwatch_role_arn
  cors_configuration              = var.api_cors_configuration
  tags                            = local.default_tags
}

