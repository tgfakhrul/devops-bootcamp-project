# DevOps Infrastructure & Automation Setup

## 🔗 Project Links

- **Project Documentation (GitHub Pages):**  
  https://tgfakhrul.github.io/devops-bootcamp-project/

- **Web Application:**  
  http://dev01.xyz/

- **Monitoring (Grafana):**  
  http://monitoring.dev01.xyz

- **GitHub Repository:**  
  https://github.com/tgfakhrul/devops-bootcamp-project

---

## Overview

This project provisions a complete **AWS-based DevOps environment** using **Terraform** and integrates **Ansible** for configuration management.

The infrastructure follows best practices including:
- Isolated networking
- Least-privilege security groups
- Automated key management
- Centralized monitoring

Sensitive infrastructure details are intentionally **not exposed** in this documentation.

---

## Architecture Summary

### VPC Configuration (`vpc.tf`)

The networking layer is created using a reusable **VPC module**.

**VPC**
- Name: `devops-vpc`
- CIDR: Private RFC1918 address space

**Subnets**
- Public Subnet  
  - Name: `devops-public-subnet`  
  - Used for internet-facing workloads
- Private Subnet  
  - Name: `devops-private-subnet`  
  - Used for internal services and management

**Route Tables**
- Public Route Table: `devops-public-route`
- Private Route Table: `devops-private-route`

**Gateways**
- Internet Gateway: `devops-igw` (public subnet access)
- NAT Gateway: `devops-ngw` (private subnet outbound access)

**Region**
- ap-southeast-1

---

## Security Groups (`sg.tf`)

Security groups are managed using a dedicated **security group module**.

### Public Security Group (`devops-public-sg`)

**Ingress Rules**
- HTTP (80) from the internet
- SSH (22) from internal network only
- Node Exporter (9100) restricted to the monitoring server

**Egress Rules**
- All outbound traffic allowed

---

### Private Security Group (`devops-private-sg`)

**Ingress Rules**
- SSH (22) from internal network only

**Egress Rules**
- All outbound traffic allowed

> 🔐 Access is restricted using least-privilege principles.  
> No public or private IP addresses are exposed in this documentation.

---

## EC2 Instances

EC2 instances are provisioned using a reusable **EC2 module**.

| Role | Name | Subnet |
|---|---|---|
| Ansible Controller | ansible-controller | Private |
| Monitoring Server | monitoring-server | Private |
| Web Server | web-server | Public |

**Instance Details**
- Instance type: `t3.micro`
- IAM role includes:
  - AWS Systems Manager (SSM) access
  - Amazon ECR pull permissions
- SSH key pair generated and managed by Terraform

---

## SSH & Automation Assets

- RSA 2048-bit SSH key generated dynamically by Terraform
- Private key stored **locally only** and never committed to Git
- Ansible inventory generated automatically
- Generated Ansible playbook:
  - `ansible/build_and_push_ecr.yml`

> 🔒 Private keys and sensitive artifacts are excluded via `.gitignore`.

---

## Amazon ECR

- Amazon ECR repository created for application container images
- Lifecycle policy configured for image retention
- Repository URL exposed via Terraform outputs (not hardcoded)

---

## Monitoring Stack

The monitoring stack is deployed using **Docker** on the monitoring server.

### Prometheus
- Scrapes:
  - Its own metrics
  - Node Exporter metrics from application servers

### Grafana
- Connected to Prometheus as a datasource
- Visualizes system and application metrics
- Used for observability and troubleshooting

All monitoring traffic flows through **internal network paths only**.

---

## Configuration Management

- Ansible is installed automatically via AWS SSM
- Used for:
  - Docker-based deployments
  - Monitoring configuration
  - Infrastructure automation tasks

---

## Conclusion

This project demonstrates a **production-aligned DevOps workflow** using:

- Infrastructure as Code (**Terraform**)
- Secure AWS networking and IAM
- Automated configuration management (**Ansible**)
- Containerized monitoring (**Prometheus & Grafana**)
- AWS-native service integration (**ECR, SSM**)

The environment is **secure, reproducible, and documentation-safe**, making it suitable for public repositories, technical reviews, and portfolio presentation.
