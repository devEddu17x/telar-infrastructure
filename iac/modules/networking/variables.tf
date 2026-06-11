variable "region" {
  description = "AWS region"
  type        = string
}

variable "name_prefix" {
  description = "Project-environment prefix for resources"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block"
  }
}

variable "availability_zones" {
  description = "List of exactly two Availability Zones, first as principal and second as replica"
  type        = list(string)
  default     = ["us-east-1c", "us-east-1d"]

  validation {
    condition     = length(distinct(var.availability_zones)) == 2
    error_message = "Exactly two distinct Availability Zones are required"
  }
}

variable "compute_subnet_cidrs" {
  description = "Map of AZ to CIDR for compute subnets"
  type        = map(string)
  default = {
    "us-east-1c" = "10.0.0.0/24"
    "us-east-1d" = "10.0.1.0/24"
  }

  validation {
    condition     = length(var.compute_subnet_cidrs) == 2
    error_message = "compute_subnet_cidrs must contain exactly two entries"
  }
}

variable "persistence_subnet_cidrs" {
  description = "Map of AZ to CIDR for persistence subnets"
  type        = map(string)
  default = {
    "us-east-1c" = "10.0.2.0/24"
    "us-east-1d" = "10.0.3.0/24"
  }

  validation {
    condition     = length(var.persistence_subnet_cidrs) == 2
    error_message = "persistence_subnet_cidrs must contain exactly two entries"
  }
}

variable "ecs_container_port" {
  description = "Port exposed by ECS Fargate containers that the ALB will forward traffic to"
  type        = number
  default     = 3000
}

variable "tags" {
  description = "Common tags applied to all networking resources"
  type        = map(string)
  default     = {}
}
