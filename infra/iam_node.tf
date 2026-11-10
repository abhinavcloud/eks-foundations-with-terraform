# Node IAM Role

resource "aws_iam_role" "eks_node_role" {
  name = "${local.name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    local.tags,
    {
      Name = "${local.name}-node-role",
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy" {
  for_each = toset([
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryPullOnly"
  ])
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}