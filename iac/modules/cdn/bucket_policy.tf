locals {
  bucket_policy_statements = [
    {
      Sid       = "EnforceHTTPSOnly"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        var.bucket_arn,
        "${var.bucket_arn}/*",
      ]
      Condition = {
        Bool = {
          "aws:SecureTransport" = "false"
        }
      }
    },
    {
      Sid    = "AllowCloudFrontOAC"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${var.bucket_arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
        }
      }
    },
  ]
}

resource "aws_s3_bucket_policy" "this" {
  count = var.manage_bucket_policy ? 1 : 0

  bucket = var.bucket_id
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.bucket_policy_statements
  })
}
