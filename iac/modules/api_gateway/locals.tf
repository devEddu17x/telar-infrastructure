locals {
  cors_allowed_origin_condition = join(" || ", [
    for origin in var.cors_configuration.allow_origins : "$origin == ${jsonencode(origin)}"
  ])

  cors_response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'${join(",", var.cors_configuration.allow_headers)}'"
    "method.response.header.Access-Control-Allow-Methods"     = "'${join(",", var.cors_configuration.allow_methods)}'"
    "method.response.header.Access-Control-Allow-Credentials" = "'${tostring(var.cors_configuration.allow_credentials)}'"
    "method.response.header.Access-Control-Max-Age"           = "'${tostring(var.cors_configuration.max_age)}'"
    "method.response.header.Access-Control-Expose-Headers"    = "'${join(",", var.cors_configuration.expose_headers)}'"
  }

  cors_response_templates = {
    "application/json" = length(var.cors_configuration.allow_origins) > 0 ? format(
      "#set($origin = $input.params(\"Origin\"))\n#if(%s)\n#set($context.responseOverride.header.Access-Control-Allow-Origin = $origin)\n#end",
      local.cors_allowed_origin_condition
    ) : ""
  }
}
