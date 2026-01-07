resource "aws_ecr_repository" "final_project" {
    name                 = "devops-bootcamp/final-project-fakhrul"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }

    tags = {
        Name = "final-project-ecr"
    }
}

output "ecr_repository_url" {
    value       = aws_ecr_repository.final_project.repository_url
    description = "The URL of the ECR repository"
}