variable "project_name" {
  description = "Nombre del proyecto, utilizado como prefijo para los recursos"
  type        = string
  default     = "telar-saas"
}

variable "secrets_manager_arn" {
  description = "ARN del secreto en Secrets Manager al que el Execution Role tendrá acceso"
  type        = string
  default     = "*" # Cambiar por ARN específico
}

variable "ssm_parameter_arn" {
  description = "ARN de los parámetros de SSM al que el Execution Role tendrá acceso"
  type        = string
  default     = "*" # Cambiar 
}

variable "s3_bucket_arn" {
  description = "ARN del bucket de S3 al que el Task Role tendrá acceso"
  type        = string
  default     = "*" # Cambiar
}
