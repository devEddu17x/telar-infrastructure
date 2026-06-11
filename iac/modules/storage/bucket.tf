resource "aws_s3_bucket" "this" {
  bucket        = "${var.name_prefix}-${var.bucket_suffix}"
  force_destroy = var.force_destroy

  tags = var.tags
}