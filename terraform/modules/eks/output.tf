output "endpoint" {
  value = aws_eks_cluster.my_first_cluster.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.my_first_cluster.name
}