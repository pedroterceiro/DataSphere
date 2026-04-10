terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "terraform-254670366345-us-east-1-an"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "modules/networking/vpc"
}

module "security" {
  source = "modules/security/kms"
}