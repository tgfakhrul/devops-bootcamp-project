# output.tf

# VPC Name
output "vpc_name" {
  description = "VPC Name"
  value       = module.vpc.name
}

# Security Group Names
output "public_security_group_name" {
  description = "Public Security Group Name"
  value       = resource.aws_security_group.public.name
}

output "private_security_group_name" {
  description = "Private Security Group Name"
  value       = resource.aws_security_group.private.name
}

# Subnet Names
output "public_subnet_name" {
  description = "Public Subnet Name"
  value       = var.public_subnet_name
}

output "private_subnet_name" {
  description = "Private Subnet Name"
  value       = var.private_subnet_name
}

# Route Table Names
output "public_route_table_name" {
  description = "Public Route Table Name"
  value       = var.public_route_table_name
}

output "private_route_table_name" {
  description = "Private Route Table Name"
  value       = var.private_route_table_name
}

# Internet Gateway Name
output "igw_name" {
  description = "Internet Gateway Name"
  value       = var.igw_name
}

# NAT Gateway Name
output "nat_gateway_name" {
  description = "NAT Gateway Name"
  value       = var.nat_gateway_name
}

output "webserver_private_ip" {
  value = module.ec2_webserver.private_ip
}

output "webserver_public_ip" {
  value = module.ec2_webserver.public_ip
}

output "ansible_ip" {
  value = module.ec2_ansible_controller.private_ip
}

output "monitoring_server_private_ip" {
  value = module.ec2_monitoring_server.private_ip
}
