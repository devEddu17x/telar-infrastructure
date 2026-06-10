variable "name_prefix" {
  description = "Prefijo para el entorno y proyecto"
  type        = string
}

variable "bucket_suffix" {
  description = "Sufijo para el nombre del bucket"
  type        = string
}

variable "force_destroy" {
  description = "Permite destruir el bucket aunque contenga objetos"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Habilita el versionado de objetos en el bucket"
  type        = bool
  default     = false # Por defecto estará apagado, como prefieres.
}

variable "tags" {
  description = "Etiquetas a aplicar al bucket S3"
  type        = map(string)
  default     = {}
}

# PARA EL PUBLIC ACCESS BLOCK

variable "block_public_acls" {
  description = "Bloquear ACLs públicas"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Bloquear políticas de bucket públicas"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignorar ACLs públicas"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restringir buckets públicos"
  type        = bool
  default     = true
}

# encryption
variable "kms_key_arn" {
  description = "ARN de la llave KMS para cifrado. Si es null, usa AES256 por defecto de S3"
  type        = string
  default     = null
}

#cors
variable "cors_rules" {
  description = "Lista de reglas CORS para aplicar al bucket"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Etiquetas a aplicar al bucket S3"
  type        = map(string)
  default     = {}
}

#logging
variable "logging_target_bucket" {
  description = "Nombre del bucket S3 de destino donde se guardarán los logs de acceso. Si es null, se desactiva el logging."
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefijo para los objetos de log grabados (ej. log/)"
  type        = string
  default     = "log/"
}