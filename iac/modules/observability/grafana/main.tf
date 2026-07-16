resource "aws_grafana_workspace" "this" {
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["SAML"]
  data_sources             = ["CLOUDWATCH"]
  description              = "Grafana workspace for ${var.name_prefix}"
  grafana_version          = var.grafana_version
  name                     = var.name
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = var.role_arn

  tags = var.tags
}
