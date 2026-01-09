# Public Security Group
module "devops_public_sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "devops-public-sg"
  description = "Security group for public web servers"
  vpc_id      = module.devops_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      description = "Prometheus Node Exporter"
      cidr_blocks = "${var.monitoring_server_ip}/32"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = module.devops_vpc.vpc_cidr_block
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Name = "devops-public-sg"
  }
}

# Private Security Group
module "devops_private_sg" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "devops-private-sg"
  description = "Security group for Ansible Controller and Monitoring Server"
  vpc_id      = module.devops_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = module.devops_vpc.vpc_cidr_block
    }
  ]

  egress_rules = ["all-all"]

  tags = {
    Name = "devops-private-sg"
  }
}