# output "Jenkins_server_public_ip" {
#   value = module.jenkins_server.public_ip
# }
# output "jump_server_public_ip" {
#   value = module.jump_server.public_ip 
# }
# output "eks_cluster_name" {
#   value = module.eks.cluster_name
# }
output "ecr_repository_urls" {
  description = "The URLs of the ECR repositories created"
  value       = module.ecr_repos.ecr_repository_urls
}