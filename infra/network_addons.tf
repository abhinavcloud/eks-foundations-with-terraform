

# VPC CNI ADDON

resource "aws_eks_addon" "network_addons_pre_node" {

  for_each                    = local.eks_addons_pre_node
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = each.value
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  tags = merge(
    local.tags,
    {
      Name = "${local.name}-network_pre_node_addons",
    },
    var.tags
  )
}

resource "aws_eks_addon" "network_addons_post_node" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_eks_node_group.eks_nodes]

  tags = merge(
    local.tags,
    {
      Name = "${local.name}-network_post_node_addons",
    },
    var.tags
  )


}


