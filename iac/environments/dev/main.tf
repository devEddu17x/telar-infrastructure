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
