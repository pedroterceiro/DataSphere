resource "aws_iam_role" "eks_csi_controller" {
  name = "${var.project_name}-eks-csi-controller-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role" "eks_auto_node" {
  name = "${var.project_name}-eks-auto-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "eks_node_group" {
  name = "${var.project_name}-eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "csi_controller" {
  role_name   = aws_iam_role.eks_csi_controller.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonS3FilesCSIDriverPolicy"
  ]
}

resource "aws_iam_role_policy_attachments_exclusive" "eks_cluster" {
  role_name   = aws_iam_role.eks_cluster.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  ]
}

resource "aws_iam_role_policy_attachments_exclusive" "eks_auto_node" {
  role_name   = aws_iam_role.eks_auto_node.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
  ]
}

resource "aws_iam_role_policy_attachments_exclusive" "eks_node_group" {
  role_name   = aws_iam_role.eks_node_group.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
