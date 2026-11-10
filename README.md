# EKS Foundations with Terraform

> Production-ready Amazon EKS foundation built from scratch using Terraform.

This project provisions a complete Amazon EKS environment including networking, IAM, managed node groups, and essential cluster add-ons. It provides a solid baseline for deploying cloud-native workloads on Kubernetes while following Infrastructure as Code (IaC) best practices.

---

## Architecture Overview

The infrastructure includes:

- Amazon VPC
- Public and Private Subnets across multiple AZs
- Internet Gateway
- NAT Gateway
- Route Tables and Associations
- Amazon EKS Control Plane
- Amazon EKS Managed Node Groups
- IAM Roles and Policies
- EKS Core Add-ons
  - VPC CNI
  - CoreDNS
  - kube-proxy
- Sample Kubernetes Workload Deployment

---

## Repository Structure

```text
.
├── infra/
│   ├── backend.tf
│   ├── backend_to_be_filled.tf
│   ├── data.tf
│   ├── eks_control_plane.tf
│   ├── eks_nodes.tf
│   ├── iam_cluster.tf
│   ├── iam_node.tf
│   ├── locals.tf
│   ├── network.tf
│   ├── network_addons.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── versions.tf
│
└── k8s/
    ├── nginx-deployment.yaml
    └── nginx-service.yaml
```

---

# Infrastructure Components

## Networking (`network.tf`)

Creates the foundational AWS networking components:

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Elastic IPs
- Route Tables
- Route Table Associations

### Network Design

```text
                    Internet
                        │
                Internet Gateway
                        │
         ┌──────────────┴──────────────┐
         │                             │
   Public Subnet AZ1            Public Subnet AZ2
         │                             │
      NAT GW                      NAT GW
         │                             │
   Private Subnet AZ1          Private Subnet AZ2
         │                             │
         └────────── EKS Nodes ────────┘
```

---

## IAM (`iam_cluster.tf`, `iam_node.tf`)

### Cluster Role

Used by the EKS Control Plane to manage AWS resources.

Key Policies:

- AmazonEKSClusterPolicy

### Node Group Role

Used by worker nodes.

Key Policies:

- AmazonEKSWorkerNodePolicy
- AmazonEKS_CNI_Policy
- AmazonEC2ContainerRegistryPullOnly

---

## EKS Control Plane (`eks_control_plane.tf`)

Creates:

- Amazon EKS Cluster
- Cluster Endpoint
- Cluster Security Group
- Kubernetes Control Plane

Private subnets are attached to the cluster for worker node placement.

---

## EKS Managed Nodes (`eks_nodes.tf`)

Creates a managed node group with:

- EC2 Worker Nodes
- Autoscaling Configuration
- IAM Integration
- Cluster Registration

---

## Cluster Add-ons (`network_addons.tf`)

Installs and manages:

### VPC CNI

Provides pod networking inside the VPC.

### CoreDNS

Handles DNS resolution for Kubernetes services.

### kube-proxy

Maintains networking rules on worker nodes.

---

## Terraform State Management

### `backend.tf`

Contains Terraform backend configuration.

### `backend_to_be_filled.tf`

Template for remote state configuration.

Example:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "eks-foundations/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locks"
  }
}
```

---

# Prerequisites

Install the following tools:

## Terraform

```bash
terraform version
```

## AWS CLI

```bash
aws --version
```

## kubectl

```bash
kubectl version --client
```

---

# Deployment

## Clone Repository

```bash
git clone https://github.com/abhinavcloud/eks-foundations-with-terraform.git

cd eks-foundations-with-terraform/infra
```

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Review Changes

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

---

# Configure kubectl

After the cluster is successfully created:

```bash
aws eks update-kubeconfig \
  --region ap-south-1 \
  --name eks-foundations-cluster
```

Verify access:

```bash
kubectl get nodes
```

Expected output:

```bash
NAME                          STATUS   ROLES    AGE
ip-10-0-x-x.ec2.internal      Ready    <none>   5m
```

---

# Validate Cluster Add-ons

List installed add-ons:

```bash
aws eks list-addons \
  --cluster-name eks-foundations-cluster
```

Check addon health:

```bash
aws eks describe-addon \
  --cluster-name eks-foundations-cluster \
  --addon-name vpc-cni
```

Verify pods:

```bash
kubectl get pods -n kube-system
```

---

# Deploy Sample Application

Navigate to the Kubernetes manifests folder:

```bash
cd ../k8s
```

Deploy NGINX:

```bash
kubectl apply -f nginx-deployment.yaml

kubectl apply -f nginx-service.yaml
```

Verify resources:

```bash
kubectl get deployments

kubectl get pods

kubectl get svc
```

---

# Useful Commands

## View Cluster Information

```bash
aws eks describe-cluster \
  --name eks-foundations-cluster
```

## View Nodes

```bash
kubectl get nodes -o wide
```

## View All Resources

```bash
kubectl get all -A
```

## View System Components

```bash
kubectl get pods -n kube-system
```

## View Add-ons

```bash
aws eks list-addons \
  --cluster-name eks-foundations-cluster
```

---

# Destroy Infrastructure

When no longer required:

```bash
terraform destroy
```

---

# Security Best Practices

This project follows several AWS and Kubernetes best practices:

- Worker nodes are deployed in private subnets.
- Internet access is controlled through NAT Gateways.
- IAM roles are separated for cluster and node groups.
- EKS-managed security groups are used.
- Remote Terraform state is supported.
- State locking can be enabled using DynamoDB.

---

# Future Enhancements

Potential additions:

- AWS Load Balancer Controller
- Cluster Autoscaler
- Karpenter
- EBS CSI Driver
- EFS CSI Driver
- ExternalDNS
- Cert Manager
- ArgoCD
- Prometheus & Grafana
- Fluent Bit
- Amazon CloudWatch Container Insights

---

# Learning Outcomes

By building this project, you gain hands-on experience with:

- Terraform Fundamentals
- Amazon EKS
- AWS Networking
- IAM Design
- Kubernetes Operations
- EKS Add-ons
- Infrastructure as Code
- Production-grade AWS Architectures

---

## Author

**Abhinav Cloud**

AWS | Terraform | Kubernetes | AI Solutions Architecture