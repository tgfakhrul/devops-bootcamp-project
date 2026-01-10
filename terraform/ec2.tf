# Web Server (Public)

module "ec2_webserver" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "web-server"
  ami                    = var.ami
  instance_type          = var.instance_type

  subnet_id              = module.devops_vpc.public_subnets[0]
  private_ip             = var.web_server_ip
  associate_public_ip_address = true

  create_security_group  = false # Prevent auto SG creation
  vpc_security_group_ids = [
    module.devops_public_sg.security_group_id
  ]

  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name

  user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname web-server
echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname.cfg
EOF

  tags = {
    Name        = "web-server"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Elastic IP for Web Server
resource "aws_eip" "web_eip" {
  domain   = "vpc"
  instance = module.ec2_webserver.id

  tags = {
    Name = "web-server-eip"
  }
}

# Ansible Controller (Private)
module "ec2_ansible_controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "ansible-controller"
  ami                    = var.ami
  instance_type          = var.instance_type

  subnet_id              = module.devops_vpc.private_subnets[0]
  private_ip             = var.ansible_ip
  associate_public_ip_address = false

  create_security_group  = false # Prevent auto SG creation
  vpc_security_group_ids = [
    module.devops_private_sg.security_group_id
  ]

  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name

  user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname ansible-controller
echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname.cfg
EOF

  tags = {
    Name        = "ansible-controller"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Monitoring Server (Private)
module "ec2_monitoring_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                   = "monitoring-server"
  ami                    = var.ami
  instance_type          = var.instance_type

  subnet_id              = module.devops_vpc.private_subnets[0]
  private_ip             = var.monitoring_server_ip
  associate_public_ip_address = false

  create_security_group  = false # Prevent auto SG creation
  vpc_security_group_ids = [
    module.devops_private_sg.security_group_id
  ]

  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name

  user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname monitoring-server
echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname.cfg
EOF

  tags = {
    Name        = "monitoring-server"
    Terraform   = "true"
    Environment = "dev"
  }
}
