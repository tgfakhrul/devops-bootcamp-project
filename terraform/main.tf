terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.27"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/24"

  azs             = ["ap-southeast-1a"]
  private_subnets = ["10.0.0.128/25"]
  public_subnets  = ["10.0.0.0/25"]

  enable_nat_gateway = true
  enable_vpn_gateway = false    #VPN not required

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
  # Subnet Names
  public_subnet_tags = {
    Name = var.public_subnet_name
  }
  private_subnet_tags = {
    Name = var.private_subnet_name
  }

  # Route Table Names
  public_route_table_tags = {
    Name = var.public_route_table_name
  }
  private_route_table_tags = {
    Name = var.private_route_table_name
  }

  # IGW Name
  igw_tags = {
    Name = var.igw_name
  }

  # NAT Gateway Name
  nat_gateway_tags = {
    Name = var.nat_gateway_name
  }
}

module "security-group-public" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name = "devops-public-sg"
  description = "Web Server Security Group"
  vpc_id = module.vpc.vpc_id

# Ingress Rules
  ingress_with_cidr_blocks = [
    # HTTP -Allow From Everywhere
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP from everywhere"
      cidr_blocks = "0.0.0.0/0"
    },
    # Prometheus Node Exporter
    {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      description = "Prometheus Node Exporter from Monitoring Server"
      cidr_blocks = "0.0.0.0/0" #need fix Allow from Monitoring Server IP
    },
    # SSH from VPC subnet only
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from VPC CIDR"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  # Allow All Outbound Traffic
  egress_rules = ["all-all"]
}

module "security-group-private" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = "devops-private-sg"
  description = "Ansible Controller & Monitoring Server Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}

