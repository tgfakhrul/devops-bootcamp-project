resource "aws_ssm_document" "install_ansible" {
  name          = "InstallAnsible"
  document_type = "Command"

  content = <<DOC
{
  "schemaVersion": "2.2",
  "description": "Install Ansible on Ubuntu EC2",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "InstallAnsible",
      "inputs": {
        "runCommand": [
          "sudo apt-get update -y",
          "sudo apt-get upgrade -y",
          "sudo apt-get install -y software-properties-common",
          "sudo apt-add-repository --yes --update ppa:ansible/ansible",
          "sudo apt-get install -y ansible",
          "ansible --version"
          "curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb""
          "sudo dpkg -i session-manager-plugin.deb"
        ]
      }
    }
  ]
}
DOC
}

resource "aws_ssm_association" "ansible_install" {
  name = aws_ssm_document.install_ansible.name

  targets {
    key    = "InstanceIds"
    values = [module.ec2_ansible_controller.id]
  }
}
