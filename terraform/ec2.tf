module "ec2_webserver" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name  = "web-server"
  ami   = var.ami
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  private_ip = var.webserver_ip
  associate_public_ip_address = true
  create_eip = true   # Allocate Elastic IP and Associate
  vpc_security_group_ids = [module.security_group_public.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name

  tags = {
    Name        = "web-server"
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_ansible_controller" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "ansible-controller"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.vpc.private_subnets[0]
  private_ip = var.ansible_ip
  associate_public_ip_address = false
  vpc_security_group_ids = [module.security_group_private.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name

  tags = {
    Name        = "ansible-controller"
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_monitoring_server" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "monitoring-server"
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = module.vpc.private_subnets[0]
  private_ip = var.monitoringserver_ip
  associate_public_ip_address = false
  vpc_security_group_ids = [module.security_group_private.security_group_id]
  iam_instance_profile = aws_iam_instance_profile.devops_ssm_profile.name
  
  user_data = <<-EOF
                    #!/bin/bash
                    sudo apt update && sudo apt upgrade -y
                    sudo apt install pipx -y
                    pipx install --include-deps ansible
                    pipx ensurepath
                    EOF

  tags = {
    Name        = "monitoring-server"
    Terraform   = "true"
    Environment = "dev"
  }
}