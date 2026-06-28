resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name  = "/${var.name_prefix}/${each.key}"
  type  = "SecureString"
  value = each.value
  tags  = var.tags
}
