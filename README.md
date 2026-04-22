# DataSphere: Learning EKS and CSI Driver
Build an AWS infrastructure using Terraform. Used for training and learning of best practices.

# Prerequisites
- Terraform v1.14.9 or greater
- AWS
  - KMS
  - IAM
  - VPC
  - EKS

# Project Structure
```
DataSphere
├── main.tf # Main terraform file, contains global configurations
├── modules # Stores AWS modules
│   ├── compute # Stores modules related to computing
│   │   └── eks
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   ├── networking # Stores modules related to network
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variables.tf
│   └── security # Stores modules related to security
│       ├── iam
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variables.tf
│       └── kms
│           ├── main.tf
│           ├── output.tf
│           └── variables.tf
├── output.tf # Returns mandatory global variables
├── pyproject.toml
├── README.md # DataSphere's Documentation
├── TASK.md # Task that originated DataSphere
└── variables.tf # Global Variables
```
# Infrastructure Diagram
photo

# Infrastructure Description
## Compute
- EKS Cluster
  1x EKS cluster (version 1.35)
  - Authentication mode: API_AND_CONFIG_MAP
  - Endpoint access: Both private and public enabled
  - Deployed in private subnets across 3 AZs
  - Bootstrap self-managed addons enabled
  - Node Groups
    1x managed node group (general purpose)
    - Instance type: t2.medium
    - AMI: Amazon Linux 2023 (AL2023_x86_64_STANDARD)
    - Scaling: Min 1, Desired 1, Max 2 nodes
    - Deployed in private subnets
  - EKS Addons
    - AWS EBS CSI Driver (for persistent block storage)
    - AWS EFS CSI Driver (for persistent file storage)
    - EKS Pod Identity Agent
  - Pod Identity Associations
    2x pod identity associations for CSI drivers (EBS and EFS)
    - Namespace: kube-system
    - Service accounts: ebs-csi-controller-sa, efs-csi-controller-sa
    - Using Instance Type "t2.medium"
  - Addons:
    3x Addons
    - EBS CSI Driver
    - EFS CSI Driver
    - Pod Identity Agent
    

## Networking
- VPC
  1x VPC using a /16 CIDR block
  - Subnets
    6x subnets using a /20 CIDR block 
    - 3x private subnets (1 per AZ)
    - 3x public subnets (1 per AZ)
  - Route Tables
    3x private route tables with 0.0.0.0 destination pointing to a zonal NAT Gateway (1 per/AZ, association with private subnets)
    1x public route table with 0.0.0.0 destionation pointing to a Internet Gateway (association with public subnets)
  - Internet Gateway
    1x Internet Gateway
  - NAT Gateway
    3x Zonal NAT Gateway (1 per/AZ, attached to public subnets )
  - Elastic IP Addresses 
    3x Elastic IP Addresses used for NAT Gateways

## Security


# Deploy
Before deploying, validate your configuration first.
```bash
terraform validate
```
Plan the changes before applying it.
```bash
terraform plan
```
Apply the changes if the resources meets your requirements.
```bash
terraform apply
```