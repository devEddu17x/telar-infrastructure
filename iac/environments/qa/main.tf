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
  source        = "../../modules/storage"
  name_prefix   = local.name_prefix
  bucket_suffix = "images"
  force_destroy = var.s3_images_force_destroy
  cors          = var.s3_images_cors
  tags          = local.default_tags
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
}
