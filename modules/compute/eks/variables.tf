variable "eks_cluster_role" {
  description = "The IAM Role should be used for EKS Cluster"
}

variable "private_subnets" {
  description = "A variable that stores every private subnet in the environment"
}