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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name

  user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname web-server
echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname.cfg
EOF

  tags = {
    Name        = "web-server"
    Environment = "dev"
    Role        = "web"
    Node        = "web-01"
    Terraform   = "yes"
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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name

  user_data_replace_on_change = true
  user_data = <<-EOF
                #!/bin/bash

                #wait 2 minutes for ssm-user to be created
                sleep 120

                # set hostname
                hostnamectl set-hostname ansible-controller
                echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname

                # create ssh folder
                mkdir -p /home/ubuntu/.ssh
                chmod 700 /home/ubuntu/.ssh

                # add private key to ssh folder
                cat > /home/ubuntu/.ssh/ansible-key.pem << 'PRIVKEY'
                ${tls_private_key.ssh_key.private_key_pem}
                PRIVKEY

                chmod 600 /home/ubuntu/.ssh/ansible-key.pem
                chown ubuntu:ubuntu /home/ubuntu/.ssh -R
                
            
                # For ssm-user
                mkdir -p /home/ssm-user/.ssh
                cp /home/ubuntu/.ssh/ansible-key.pem /home/ssm-user/.ssh/
                chown ssm-user:ssm-user /home/ssm-user/.ssh/ansible-key.pem
                chmod 600 /home/ssm-user/.ssh/ansible-key.pem
                chown ssm-user:ssm-user /home/ssm-user/.ssh -R

                # Pre-create Ansible directories for ssm-user
                mkdir -p /home/ssm-user/.ansible/tmp
                chown -R ssm-user:ssm-user /home/ssm-user/.ansible
                chmod -R 700 /home/ssm-user/.ansible

                apt update && apt upgrade -y
                apt install -y ansible
                ansible-galaxy install geerlingguy.docker
                EOF
                
  tags = {
    Name        = "ansible-controller"
    Environment = "dev"
    Role        = "ansible-controller"
    Node        = "ansible-01"
    Terraform   = "yes"
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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name

  user_data = <<-EOF
#!/bin/bash
hostnamectl set-hostname monitoring-server
echo "preserve_hostname: true" > /etc/cloud/cloud.cfg.d/99_hostname.cfg
EOF

  tags = {
    Name        = "monitoring-server"
    Environment = "dev"
    Role        = "monitoring"
    Node        = "monitoring-01"
    Terraform   = "yes"
  }
}