provider "aws" {
  region = "ap-south-1"
}
resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repository_names)

  name = each.value
  force_delete = true
  
  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}