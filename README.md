# DataSphere: 
Build an AWS infrastructure using Terraform. Used for training and learning of best practices.

# Prerequisites
Terraform v1.14.9 or greater

# Services
- AWS
  - KMS
  - IAM
  - VPC
  - EKS

# Project Structure
```
. DataSphere
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