variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "public_subnet_cidrs" {
  type        = map(number)
  description = "Public subnets CIDR"

  default = {
    "192.168.0.0/20"  = 0
    "192.168.16.0/20" = 1
    "192.168.32.0/20" = 2
  }
}

variable "private_subnet_cidrs" {
  type        = map(number)
  description = "Private subnets CIDR"

  default = {
    "192.168.48.0/20" = 0
    "192.168.64.0/20" = 1
    "192.168.80.0/20" = 2
  }
}
