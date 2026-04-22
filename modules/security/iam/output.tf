output "cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "csi_controller_role_arn" {
  description = "EKS CSI controller IAM role ARN"
  value       = aws_iam_role.eks_csi_controller.arn
}

output "auto_node_role_arn" {
  description = "EKS auto node IAM role ARN"
  value       = aws_iam_role.eks_auto_node.arn
}

output "node_group_role_arn" {
  description = "EKS node group IAM role ARN"
  value       = aws_iam_role.eks_node_group.arn
}
