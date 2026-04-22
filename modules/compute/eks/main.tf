resource "aws_eks_cluster" "this" {
  name = "${var.project_name}-eks-cluster"

  role_arn = var.cluster_role_arn
  version  = "1.35"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  bootstrap_self_managed_addons = true

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.private_subnets
  }

  tags = {
    Name = "${var.project_name}-eks-cluster"
  }
}

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-eks-node-group-general"
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.private_subnets
  ami_type        = "AL2023_x86_64_STANDARD"
  instance_types  = ["t2.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = var.csi_controller_role_arn

  depends_on = [aws_eks_node_group.general]
}

resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = "aws-efs-csi-driver"
  service_account_role_arn = var.csi_controller_role_arn

  depends_on = [aws_eks_node_group.general]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [aws_eks_node_group.general]
}

resource "aws_eks_pod_identity_association" "efs_csi" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "efs-csi-controller-sa"
  role_arn        = var.csi_controller_role_arn

  depends_on = [aws_eks_addon.efs_csi_driver]
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = var.csi_controller_role_arn

  depends_on = [aws_eks_addon.ebs_csi_driver]
}
