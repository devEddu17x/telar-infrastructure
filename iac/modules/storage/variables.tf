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