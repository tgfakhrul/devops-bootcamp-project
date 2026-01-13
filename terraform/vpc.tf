module "devops_vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr_block

  azs = var.azs

  public_subnets  = [var.public_subnet_cidr]
  private_subnets = [var.private_subnet_cidr]

  public_subnet_names  = [var.public_subnet_name]
  private_subnet_names = [var.private_subnet_name]

  # Route table names
  public_route_table_tags = {
    Name = var.public_route_table_name
  }

  private_route_table_tags = {
    Name = var.private_route_table_name
  }

  # Internet Gateway
  create_igw = true
  igw_tags = {
    Name = var.igw_name
  }

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  nat_gateway_tags = {
    Name = var.nat_gateway_name
  }

  tags = {
    Environment = "devops"
  }
}