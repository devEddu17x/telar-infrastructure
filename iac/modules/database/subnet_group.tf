resource "aws_db_subnet_group" "this" {
  name        = "${var.name_prefix}-aurora-subnet-group"
  description = "Subnet group for Aurora cluster ${var.name_prefix}"
  subnet_ids  = var.subnet_ids

  tags = var.tags
}
