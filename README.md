# DataSphere: Learning EKS and CSI Driver
Build an AWS infrastructure using Terraform. Used for training and learning best practices.

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
  - 1x EKS cluster (version 1.35)
    - Authentication mode: API_AND_CONFIG_MAP
    - Endpoint access: Both private and public enabled
    - Deployed in private subnets across 3 AZs
    - Bootstrap self-managed addons enabled
  - Node Groups
    - 1x managed node group (general purpose)
      - Instance type: t2.medium
      - AMI: Amazon Linux 2023 (AL2023_x86_64_STANDARD)
      - Scaling: Min 1, Desired 1, Max 2 nodes
      - Deployed in private subnets
  - EKS Addons
    - 3x addons
      - AWS EBS CSI Driver (for persistent block storage)
      - AWS EFS CSI Driver (for persistent file storage)
      - EKS Pod Identity Agent
  - Pod Identity Associations
    - 2x pod identity associations for CSI drivers
      - Namespace: kube-system
      - Service accounts: ebs-csi-controller-sa, efs-csi-controller-sa

## Networking
- VPC
  - 1x VPC using a /16 CIDR block
  - Subnets
    - 6x subnets using a /20 CIDR block 
      - 3x private subnets (1 per AZ)
      - 3x public subnets (1 per AZ)
  - Route Tables
    - 4x route tables
      - 3x private route tables with 0.0.0.0 destination pointing to a zonal NAT Gateway (1 per AZ, associated with private subnets)
      - 1x public route table with 0.0.0.0 destination pointing to an Internet Gateway (associated with public subnets)
  - Internet Gateway
    - 1x Internet Gateway
  - NAT Gateways
    - 3x zonal NAT Gateways (1 per AZ, attached to public subnets)
  - Elastic IP Addresses
    - 3x Elastic IPs used for NAT Gateways

## Security
- IAM
  - 4x IAM Roles
  - CSI Controller Role
    - A role attached to CSI addons, it gives the necessary permissions to make the environment work properly, contains the following trust policy:
      ```json
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Action": [
              "sts:AssumeRole",
              "sts:TagSession"
            ],
            "Effect": "Allow",
            "Principal": {
              "Service": "pods.eks.amazonaws.com"
            }
          }
        ]
      }
      ```
      The following policies managed by AWS are used in this role:\
      EBSCSIDriverPolicy: ```arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy```\
      ElasticFileSystemUtils: ```arn:aws:iam::aws:policy/AmazonElasticFileSystemsUtils```\
      S3FilesCSIDriverPolicy: ```arn:aws:iam::aws:policy/service-role/AmazonS3FilesCSIDriverPolicy```\
      S3ReadOnlyAccess: ```arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess```


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