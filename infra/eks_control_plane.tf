resource "aws_eks_cluster" "eks_cluster" {
  name = "${local.name}-cluster"

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn                      = aws_iam_role.eks_cluster_role.arn
  version                       = "1.36"
  bootstrap_self_managed_addons = false
  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids = [
      for subnet in aws_subnet.private_subnets : subnet.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = "${local.name}-cluster",
    },
    var.tags
  )

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy
  ]

}

