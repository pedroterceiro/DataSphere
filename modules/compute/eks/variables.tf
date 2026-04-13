variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cluster_role_arn" {
  type        = string
  description = "EKS cluster IAM role ARN"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for EKS cluster"
}

variable "csi_controller_role_arn" {
  type        = string
  description = "CSI controller IAM role ARN"
}

variable "auto_node_role_arn" {
  type        = string
  description = "EKS auto node IAM role ARN"
}

variable "node_group_role_arn" {
  type        = string
  description = "EKS node group IAM role ARN"
}

