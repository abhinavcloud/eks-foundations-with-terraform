output "cluster_name" {
    value = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
    value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
    value = aws_eks_cluster.eks_cluster.version
}

output "node_group_name" {
    value = aws_eks_node_group.eks_nodes.node_group_name
}

output "update_kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${data.aws_region.current.region} --name ${aws_eks_cluster.eks_cluster.name}"
}