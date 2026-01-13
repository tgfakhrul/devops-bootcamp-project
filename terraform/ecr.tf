resource "aws_ecr_repository" "final_project" {
  name                 = "devops-bootcamp/final-project-fakhrul"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "final-project-fakhrul"
    Environment = "dev"
  }
}

resource "aws_ecr_lifecycle_policy" "final_project" {
  repository = aws_ecr_repository.final_project.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.final_project.repository_url
}
