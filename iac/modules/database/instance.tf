resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.name_prefix}-aurora-writer"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_subnet_group_name = aws_db_subnet_group.this.name

  availability_zone   = var.availability_zones[0]
  publicly_accessible = false

  tags                       = merge(var.tags, { Role = "writer" })
  auto_minor_version_upgrade = true
}

resource "aws_rds_cluster_instance" "reader" {
  identifier         = "${var.name_prefix}-aurora-reader"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  db_subnet_group_name = aws_db_subnet_group.this.name

  availability_zone   = var.availability_zones[1]
  publicly_accessible = false

  tags                       = merge(var.tags, { Role = "reader" })
  auto_minor_version_upgrade = true
}
