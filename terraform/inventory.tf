resource "local_file" "ansible_inventory" {
  depends_on = [
    module.ec2_webserver,
    module.ec2_ansible_controller,
    module.ec2_monitoring_server
  ]

  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    web_server_id               = module.ec2_webserver.id
    web_server_private_ip       = module.ec2_webserver.private_ip

    ansible_controller_id       = module.ec2_ansible_controller.id
    ansible_controller_private_ip = module.ec2_ansible_controller.private_ip

    monitoring_server_id        = module.ec2_monitoring_server.id
    monitoring_server_private_ip = module.ec2_monitoring_server.private_ip

    ecr_repo_url = aws_ecr_repository.final_project.repository_url
  })
}
