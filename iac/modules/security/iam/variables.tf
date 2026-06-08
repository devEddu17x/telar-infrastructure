variable "project_name" {
  description = "Nombre del proyecto, utilizado como prefijo para los recursos"
  type        = string
  default     = "telar-saas"
}

variable "secrets_manager_arns" {
  description = "Lista de ARNs de secretos en Secrets Manager a los que el Execution Role tendrá acceso"
  type        = list(string) #Ahora se usa list para manejar múltiples secretos
  default     = ["*"] # Cambiar por ARNs especifico
}

variable "ssm_parameter_arns" {
  description = "Lista de ARNs de parámetros en SSM Parameter Store a los que el Execution Role tendrá acceso"
  type        = list(string)
  default     = ["*"] # Cambiar
}

variable "s3_bucket_arns" {
  description = "Lista de ARNs de buckets S3 a los que el Task Role tendrá acceso"
  type        = list(string)
  default     = ["*"] # Cambiar
}

variable "cognito_user_pool_arn" {
  description = "ARN del User Pool de Cognito. Requerido para que el backend pueda administrar usuarios (crear, listar, actualizar)."
  type        = string
  default     = "*" # Cambiar
}

