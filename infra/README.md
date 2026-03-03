# SkillNest Infrastructure

The repository manages SkillNest's entire cloud infrastructure using Terraform.

## 🏗 Architecture Overview

The system includes:

- VPC (Public + Private Subnet)
- Application Load Balancer
- ECS Fargate (Backend)
- ECR (Docker images)
- S3 (Frontend hosting)
- CloudFront
- ACM (SSL)
- Route53 (DNS)

Frontend:
User → CloudFront → S3

Backend:
User → ALB → ECS → Database

Database: 
- PosgreSQL is powered by Neon (serverless, managed external service)

## 🛠 Tech Stack

- Terraform
- AWS
- GitHub Actions
- OIDC IAM Role

## 📂 Repository Structure

```
infra/ # for cloud Deployment
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   ├── versions.tf
   ├── alb.tf
   ├── backend.tf
   ├── cloudfront.tf
   ├── ecr.tf
   ├── ecs.tf
   ├── iam.tf
   ├── s3.tf
   ├── sg.tf
   ├── vpc.tf
   └── README.md

```

## Infrastructure Architecture
![Architecture Diagram](./diagrams/AWS%20Cloud%20Infrastructure.png)

## ⚙️ Prerequisites

- AWS CLI
- Terraform >= 1.6
- GitHub OIDC configured

## 🚀 Deploy Infrastructure

### 1️⃣ Init

terraform init

### 2️⃣ Plan

terraform plan -var-file="terraform.tfvars"

### 3️⃣ Apply

terraform apply -var-file="terraform.tfvars"

## 💥 Destroy Infrastructure

terraform destroy -var-file="terraform.tfvars"

## 🔐 CI/CD

- Push code backend → Build Docker → Push ECR → Deploy ECS
- Push frontend → Build → Upload S3

Workflow is located in:

.github/workflows/

## 🌍 Environments

- main → production
- stage → staging