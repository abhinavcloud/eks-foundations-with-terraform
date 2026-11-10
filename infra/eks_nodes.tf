resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.name}-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = values(aws_subnet.private_subnets)[*].id

  scaling_config {
    desired_size = var.desired_node_number
    max_size     = var.maximum_node_number
    min_size     = var.minimum_node_number
  }

  capacity_type  = "SPOT"
  instance_types = var.node_group_instance_type

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_role_policy,
    aws_iam_role.eks_node_role,
    aws_eks_addon.network_addons_pre_node
  ]

  tags = merge(
    local.tags,
    {
      Name = "${local.name}-node",
    },
    var.tags
  )

}
