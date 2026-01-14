# DevOps Infrastructure & Automation Setup

## Overview

This project provisions a complete **AWS-based DevOps environment** using **Terraform** and integrates **Ansible** for configuration management and **Docker-based monitoring**.  
The infrastructure follows best practices with isolated networking, security groups, automated key management, and centralized monitoring — **without exposing sensitive network details**.

---

## Architecture Summary

### Networking (VPC)
- **Region:** ap-southeast-1
- **VPC CIDR:** Private RFC1918 address space
- **Subnets:**
  - Public subnet for internet-facing workloads
  - Private subnet for internal services and management
- Internet Gateway for public access
- NAT Gateway for outbound internet access from private subnets
- Separate route tables for public and private traffic

---

## Security Groups

### Public Security Group (`devops-public-sg`)
- **Ingress**
  - HTTP (80) from the internet
  - SSH (22) from internal network only
  - Node Exporter (9100) restricted to the monitoring server
- **Egress**
  - All outbound traffic allowed

### Private Security Group (`devops-private-sg`)
- **Ingress**
  - SSH (22) from internal network only
- **Egress**
  - All outbound traffic allowed

> 🔐 All access is restricted using least-privilege networking rules.  
> No public IP addresses or internal IP ranges are exposed in documentation.

---

## EC2 Instances

| Role | Name | Subnet |
|---|---|---|
| Ansible Controller | ansible-controller | Private |
| Monitoring Server | monitoring-server | Private |
| Web Server | web-server | Public |

**Instance Details**
- Instance type: `t3.micro`
- IAM role with:
  - AWS Systems Manager (SSM) access
  - Amazon ECR pull permissions
- SSH key pair generated and managed by Terraform

---

## SSH & Automation Assets

- RSA 2048-bit SSH key generated dynamically by Terraform
- Private key stored **locally only** (never committed to Git)
- Ansible inventory generated automatically
- Generated Ansible playbook:
  - `ansible/build_and_push_ecr.yml`

> 🔒 Private keys and sensitive files are excluded via `.gitignore`.

---

## Amazon ECR

- Amazon ECR repository created for application images
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

All monitoring communication occurs over **internal network paths only**.

---

## Configuration Management

- Ansible installed automatically via AWS SSM
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
