output "ecr_repository_urls" {
  description = "The URLs of the ECR repositories created"
  value       = { for repo in aws_ecr_repository.repos : repo.name => repo.repository_url }
}