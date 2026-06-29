resource "aws_backup_vault" "this" {
  name          = "${var.name_prefix}-rds-backup-vault"
  force_destroy = var.backup_vault_force_destroy

  tags = var.tags
}

resource "aws_backup_plan" "this" {
  name = "${var.name_prefix}-rds-backup-plan"

  rule {
    rule_name         = "${var.name_prefix}-rds-backup-rule"
    target_vault_name = aws_backup_vault.this.name
    schedule          = var.backup_schedule

    lifecycle {
      delete_after = var.backup_retention_days
    }
  }

  tags = var.tags
}

resource "aws_backup_selection" "this" {
  iam_role_arn = var.backup_iam_role_arn
  name         = "${var.name_prefix}-rds-backup-selection"
  plan_id      = aws_backup_plan.this.id

  resources = [
    aws_rds_cluster.this.arn
  ]
}
