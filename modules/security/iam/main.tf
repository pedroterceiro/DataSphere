resource "aws_iam_role" "eks-csi-controller" {
  name = "eks-pod-identity-efs-csi-controller"
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
  name = "eks-pod-identity-efs-csi-node"
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

resource "aws_iam_role_policy_attachments_exclusive" "efs-csi-controller-sa" {
  role_name = aws_iam_role.eks-csi-controller.name
  policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "arn:aws:iam::aws:policy/service-role/AmazonS3FilesCSIDriverPolicy"]
}

resource "aws_iam_role_policy_attachments_exclusive" "efs-csi-node-sa" {
  role_name = aws_iam_role.eks-csi-node.name
  policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils"]
}
