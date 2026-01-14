# DevOps Infrastructure & Automation Setup

## Overview

This project provisions a complete **AWS-based DevOps environment** using **Terraform** and integrates **Ansible** for configuration management and **Docker-based monitoring**. The infrastructure follows best practices with isolated networking, security groups, automated key management, and monitoring.

---

## Architecture Summary

### Networking (VPC)
- **Region:** ap-southeast-1
- **VPC CIDR:** 10.0.0.0/24
- **Public Subnet:** 10.0.0.0/25
- **Private Subnet:** 10.0.0.128/25
- Internet Gateway for public access
- NAT Gateway for private subnet outbound access
- Separate route tables for public and private subnets

## Security Groups

### Public Security Group (devops-public-sg)
- Ingress:
  - HTTP (80) from 0.0.0.0/0
  - SSH (22) from 10.0.0.0/24
  - Node Exporter (9100) from Monitoring Server (10.0.0.136)
- Egress:
  - All traffic allowed

### Private Security Group (devops-private-sg)
- Ingress:
  - SSH (22) from 10.0.0.0/24
- Egress:
  - All traffic allowed

---

## EC2 Instances

| Role | Name | Private IP | Subnet |
|---|---|---|---|
| Ansible Controller | ansible-controller | 10.0.0.135 | Private |
| Monitoring Server | monitoring-server | 10.0.0.136 | Private |
| Web Server | web-server | 10.0.0.5 | Public |

**Instance Details**
- Instance type: t3.micro
- IAM role with SSM and ECR pull permissions
- SSH key managed by Terraform

---

## SSH & Automation Assets

- RSA 2048-bit SSH key generated via Terraform
- Private key stored locally: `ansible/ansible-key.pem` (permission 0400)
- Auto-generated Ansible inventory
- Generated Ansible playbook:
  - `ansible/build_and_push_ecr.yml`

---

## Amazon ECR

- ECR repository created:
  - `devops-bootcamp/final-project-fakhrul`
- Lifecycle policy applied
- Repository URL exported as Terraform output

---

## Monitoring Stack

Deployed on the monitoring server using Docker:

- **Prometheus**
  - Scrapes:
    - Prometheus itself (localhost:9090)
    - Node Exporter on web-server (10.0.0.5:9100)
- **Grafana**
  - Connected to Prometheus datasource
  - Visualizes system metrics from Node Exporter

## Configuration Management

- Ansible installed automatically via AWS SSM
- Used for:
  - Docker-based deployments
  - Monitoring configuration
  - Automation tasks


## Conclusion

This project demonstrates a full DevOps workflow using:
- Infrastructure as Code (Terraform)
- Secure AWS networking and IAM
- Automated configuration management (Ansible)
- Containerized monitoring (Prometheus & Grafana)
- AWS-native integrations (ECR, SSM)
