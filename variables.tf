variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
  default     = "datasphere"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}
