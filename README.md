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

## Networking
- VPC
  1x VPC using a /16 CIDR block
  - Subnets
    4x subnets using a /20 CIDR block
    - 2x private subnets
    - 2x public subnets
  - Route Tables
    3x private route tables with 0.0.0.0 destination pointing to a zonal NAT Gateway
    1x public route table with 0.0.0.0 destionation pointing to a Internet Gateway
  - Internet Gateway
    1x Internet Gateway
  - NAT Gateway
    3x Zonal NAT Gateway
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