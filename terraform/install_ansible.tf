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
          "set -e",
          "sudo apt-get update -y",
          "sudo apt-get upgrade -y",
          "sudo apt-get install -y software-properties-common",
          "sudo apt-add-repository --yes --update ppa:ansible/ansible",
          "sudo apt-get install -y ansible",
          "ansible --version"
        ]
      }
    }
  ]
}
DOC
}
