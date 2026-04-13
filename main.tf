terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "terraform-860165147234-us-east-1-an"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

module "vpc" {
  source = "./modules/networking/vpc"
}

module "kms" {
  source = "./modules/security/kms"
}

module "iam" {
  source = "./modules/security/iam"
}

module "eks" {
  source = "./modules/compute/eks"
  eks_cluster_role = module.iam.eks_cluster_role
  private_subnets = module.vpc.private_subnets
}