# VPC and Networking Variables
variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "eks-foundations"
}

variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Basic Tags applied to every resource"
  type        = map(string)
  default = {
    "Owner" = "Abhinav Kumar"
  }
}

variable "node_group_instance_type" {
  description = "List of type of instances in node group"
  type        = list(string)
  default     = ["t2.micro", "t3.micro", "t2.small", "t3.small"]
}


variable "minimum_node_number" {
  description = "Minimum Numbers of Nodes"
  type        = number
  default     = 2
}

variable "maximum_node_number" {
  description = "Maximmum Numbers of Nodes"
  type        = number
  default     = 4
}

variable "desired_node_number" {
  description = "Desired Numbers of Nodes"
  type        = number
  default     = 2
}



