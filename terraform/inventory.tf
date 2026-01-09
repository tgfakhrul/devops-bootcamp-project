resource "local_file" "ansible_inventory" {
  depends_on = [
    module.ec2_webserver,
    module.ec2_ansible_controller,
    module.ec2_monitoring_server
  ]

  content = templatefile("${path.module}/inventory.tftpl", {
    instances = [
      module.ec2_webserver,
      module.ec2_ansible_controller,
      module.ec2_monitoring_server
    ]
    web_server           = module.ec2_webserver
    ansible_controller   = module.ec2_ansible_controller
    monitoring_server    = module.ec2_monitoring_server

    prometheus_node_exporter = [
      module.ec2_webserver,
      module.ec2_ansible_controller,
      module.ec2_monitoring_server
    ]
    ecr_repo_url = aws_ecr_repository.final_project.repository_url
  })
  filename = "../ansible/inventory.ini"
}
