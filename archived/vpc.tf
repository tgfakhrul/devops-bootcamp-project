module "devops_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "devops-vpc"
  cidr = "10.0.0.0/24"

  azs = ["ap-southeast-1a"]

  public_subnets  = ["10.0.0.0/25"]
  private_subnets = ["10.0.0.128/25"]

  public_subnet_names  = ["devops-public-subnet"]
  private_subnet_names = ["devops-private-subnet"]

  # Route tables
  public_route_table_tags = {
    Name = "devops-public-route"
  }

  private_route_table_tags = {
    Name = "devops-private-route"
  }

  # Internet Gateway
  create_igw = true
  igw_tags = {
    Name = "devops-igw"
  }

  # NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  nat_gateway_tags = {
    Name = "devops-ngw"
  }

  tags = {
    Environment = "devops"
  }
}
