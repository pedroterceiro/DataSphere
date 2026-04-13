terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-860165147234-us-east-1-an"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "DataSphere"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source = "./modules/networking/vpc"

  project_name = var.project_name
  environment  = var.environment
}

module "kms" {
  source = "./modules/security/kms"

  project_name = var.project_name
  environment  = var.environment
}

module "iam_eks_roles" {
  source = "./modules/security/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "eks_cluster" {
  source = "./modules/compute/eks"

  project_name              = var.project_name
  environment               = var.environment
  cluster_role_arn          = module.iam_eks_roles.cluster_role_arn
  node_group_role_arn       = module.iam_eks_roles.node_group_role_arn
  auto_node_role_arn        = module.iam_eks_roles.auto_node_role_arn
  csi_controller_role_arn   = module.iam_eks_roles.csi_controller_role_arn
  private_subnets           = module.vpc.private_subnets
}