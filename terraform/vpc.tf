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