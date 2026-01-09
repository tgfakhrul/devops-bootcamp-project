variable "region" {
  description = "AWS Region"
  type = string
  default = "ap-southeast-1"
}

variable "azs" {
  description = "Availability Zones"
  type = list(string)
  default = ["ap-southeast-1a"]
}

variable "vpc_name" {
  description = "VPC Name"
  type = string
}

variable "public_subnet_name" {
    description = "Public Subnet Name"
    type = string
}

variable "private_subnet_name" {
    description = "Private Subnet Name"
    type = string     
}

variable "public_route_table_name" {
    description = "Public Route Table Name"
    type = string
}

variable "private_route_table_name" {
    description = "Private Route Table Name"
    type = string
}

variable "igw_name" {
    description = "Internet Gateway Name"
    type = string
}

variable "nat_gateway_name" {
    description = "NAT Gateway Name"
    type = string
}

variable "instance_type" {
  description = "Default Instance Type"
  default = "t3.micro"
}

variable "ami" {
  description = "AMI Version"
  type = string
}

variable "web_server_ip" {
  type = string
  description = "Web Server Private IP"
}

variable "ansible_ip" {
  description = "Ansible Controller Private IP"
  type = string
}

variable "monitoring_server_ip" {
  type = string
  description = "Monitoring Server Private IP"
}