resource "local_file" "ecr_build_push_playbook" {
  filename = "../ansible/build_and_push_ecr.yml"

  content = <<-EOF
---
- name: Build and Push Docker Image to ECR
  hosts: localhost
  connection: local
  gather_facts: false

  vars:
    aws_region: "ap-southeast-1"
    repo_url: "${aws_ecr_repository.final_project.repository_url}"

  tasks:
    - name: Login to Amazon ECR (AWS CLI – stable)
      shell: |
        aws ecr get-login-password --region {{ aws_region }} \
        | docker login --username AWS --password-stdin {{ repo_url | regex_replace('/.*$', '') }}
      args:
        executable: /bin/bash

    - name: Clone lab-final-project repo
      git:
        repo: "https://github.com/Infratify/lab-final-project.git"
        dest: ./lab-final-project
        version: HEAD
        force: yes

    - name: Build Docker image
      community.docker.docker_image:
        name: my-devops-project
        tag: latest
        build:
          path: ./lab-final-project
        source: build

    - name: Tag image for ECR
      command: >
        docker tag my-devops-project:latest {{ repo_url }}:latest

    - name: Push image to ECR
      command: >
        docker push {{ repo_url }}:latest
EOF
}
