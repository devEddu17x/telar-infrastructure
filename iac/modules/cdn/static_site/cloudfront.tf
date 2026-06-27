resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.name_prefix}-cdn-oac"
  description                       = "Allow CloudFront to access the S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_function" "clean_html_routes" {
  name    = "${var.name_prefix}-clean-html-routes"
  runtime = "cloudfront-js-2.0"
  comment = "Rewrite extensionless routes to HTML"
  publish = true
  code    = file("${path.module}/../../../services/cloudfront/clean-html-routes/function.js")
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  comment             = var.comment != null ? var.comment : "${var.name_prefix} static site CDN"
  default_root_object = var.default_root_object
  price_class         = var.price_class
  tags                = var.tags

  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = var.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods          = var.allowed_methods
    cached_methods           = var.cached_methods
    target_origin_id         = var.origin_id
    viewer_protocol_policy   = var.viewer_protocol_policy
    compress                 = true
    cache_policy_id          = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed_cors_s3_origin.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.clean_html_routes.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
