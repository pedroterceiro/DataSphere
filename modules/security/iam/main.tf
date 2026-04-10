resource "aws_iam_role" "eks-csi-controller" {
  name = "eks-pod-identity-efs-csi-controller-role"
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

resource "aws_iam_role" "eks-csi-node" {
  name = "eks-pod-identity-efs-csi-node-role"
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

resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachments_exclusive" "efs-csi-controller-sa" {
  role_name = aws_iam_role.eks-csi-controller.name
  policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "arn:aws:iam::aws:policy/service-role/AmazonS3FilesCSIDriverPolicy"]
}
# TO ATTACH AT CSI ADDON

resource "aws_iam_role_policy_attachments_exclusive" "efs-csi-node-sa" {
  role_name = aws_iam_role.eks-csi-node.name
  policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils"]
}
# TO ATTACH AT CSI ADDON

resource "aws_iam_role_policy_attachments_exclusive" "eks-cluster" {
  role_name = aws_iam_role.eks-cluster-role.name
  policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy", "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy", "arn:aws:iam::aws:policy/AmazonEKSComputePolicy", "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"]
}
# TO ATTACH AT EKS CLUSTER