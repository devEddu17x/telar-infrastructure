variable "name_prefix" {
  description = "Prefix used for naming all networking resources (e.g. 'telar-dev')"
  type        = string
  default     = "networking-telar"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block (e.g. '10.0.0.0/16')."
  }
}

variable "availability_zones" {
  description = "List of Availability Zones to deploy subnets into. First AZ is treated as principal, rest as replicas."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
 
  validation {
    condition     = length(var.availability_zones) >= 2 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "At least two distinct Availability Zones are required for high availability."
  }
}

variable "subnet_newbits" {
  description = "Number of additional bits to extend the VPC CIDR for each subnet."
  type        = number
  default     = 8

  validation {
    condition = (
      var.subnet_newbits > 0 &&
      var.subnet_newbits == floor(var.subnet_newbits) &&
      pow(2, var.subnet_newbits) >= (3 * length(var.availability_zones))
    )
    error_message = "subnet_newbits must be a positive integer providing enough capacity for cidrsubnet to allocate 3 subnets per AZ across all var.availability_zones (minimum 2^var.subnet_newbits >= 3 * length(var.availability_zones))."
  }
}

variable "ecs_container_port" {
  description = "Port exposed by ECS Fargate containers that the ALB will forward traffic to"
  type        = number
  default     = 8080

  validation {
    condition     = var.ecs_container_port >= 1 && var.ecs_container_port <= 65535
    error_message = "ecs_container_port must be a valid port number between 1 and 65535."
  }
}

variable "tags" {
  description = "Common tags applied to all networking resources"
  type        = map(string)
  default     = {}
}
