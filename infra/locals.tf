
locals {
  name = var.cluster_name
  azs  = slice(data.aws_availability_zones.availibility_zones.names, 0, 2)
  tags = merge(
    {
      "Project"   = "eks-foundations",
      "ManagedBy" = "terraform"
    },
    var.tags

  )
}

locals {
  eks_addons_pre_node = {
    "addon_1" = "vpc-cni"
    "addon_2" = "kube-proxy"

  }
}
