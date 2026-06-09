variable "name_prefix" {
  description = "Prefix used for naming all resources in this module"
  type        = string
}

variable "user_pool_arn" {
  description = "ARN of the Cognito User Pool. Used to scope the Lambda invoke permission."
  type        = string
}

variable "lambdas" {
  description = "Map of Lambda functions to create. Each key is a unique identifier for the function."
  type = map(object({
    source_path            = string
    handler                = string
    runtime                = string
    description            = string
    environment_variables  = map(string)
    role_policy            = optional(string, null)
    timeout                = optional(number, 3)
    memory_size            = optional(number, 128)
  }))
}
