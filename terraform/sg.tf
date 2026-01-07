module "security_group_public" {
  source  = "terraform-aws-modules/security-group/aws"

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

module "security_group_private" {
  source  = "terraform-aws-modules/security-group/aws"

  name        = "devops-private-sg"
  description = "Ansible Controller & Monitoring Server Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}