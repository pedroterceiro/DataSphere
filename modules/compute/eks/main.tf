resource "aws_eks_cluster" "csi-ebs" {
 name = "csi-ebs-eks"

  role_arn = var.eks_cluster_role.arn
  version = "1.35"

  vpc_config {
    subnet_ids = var.private_subnets
  }
}