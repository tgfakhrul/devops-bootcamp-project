# AWS & Networking
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "cidr_block" {
  description = "Devops VPC cidr"
  type = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["ap-southeast-1a"]
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "public_subnet_name" {
  description = "Public subnet name"
  type        = string
}

variable "private_subnet_name" {
  description = "Private subnet name"
  type        = string
}

variable "public_route_table_name" {
  description = "Public route table name"
  type        = string
}

variable "private_route_table_name" {
  description = "Private route table name"
  type        = string
}

variable "igw_name" {
  description = "Internet Gateway name"
  type        = string
}

variable "nat_gateway_name" {
  description = "NAT Gateway name"
  type        = string
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI ID (Ubuntu 24.04)"
  type        = string
}

# Static Private IPs
variable "web_server_ip" {
  description = "Web server private IP"
  type        = string
}

variable "ansible_ip" {
  description = "Ansible controller private IP"
  type        = string
}

variable "monitoring_server_ip" {
  description = "Monitoring server private IP"
  type        = string
}