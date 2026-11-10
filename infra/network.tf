# VPC

resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(
    local.tags,
    {
      Name = "${local.name}_vpc"
    }
  )

}

# Public Subnets

resource "aws_subnet" "public_subnets" {
  for_each = {
    "${local.azs[0]}" = "10.0.0.0/24",
    "${local.azs[1]}" = "10.0.1.0/24",

  }

  vpc_id            = aws_vpc.cluster_vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(
    local.tags,
    {
      Name                     = "${local.name}_public_subnet_${each.key}",
      "kubernetes.io/role/elb" = "1"
    }
  )

}

# Private Subnets

resource "aws_subnet" "private_subnets" {
  for_each = {
    "${local.azs[0]}" = "10.0.16.0/20",
    "${local.azs[1]}" = "10.0.32.0/20",
  }
  vpc_id            = aws_vpc.cluster_vpc.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(
    local.tags,
    {
      Name                              = "${local.name}_private_subnet_${each.key}",
      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}



# Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = merge(
    local.tags,
    {
      Name = "${local.name}_internet_gateway"
    }
  )
}

# EIPs

resource "aws_eip" "nat_eips" {
  for_each = aws_subnet.public_subnets

  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${local.name}_nat_eip_${each.key}"
    }
  )
}


# NAT Gateways
resource "aws_nat_gateway" "nat_gateways" {
  for_each = aws_subnet.public_subnets

  allocation_id = aws_eip.nat_eips[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    local.tags,
    {
      Name = "${local.name}_nat_gateway_${each.key}"
    }
  )

  depends_on = [aws_eip.nat_eips]
}


# Public Route Tables and Route Table Associations

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    local.tags,
    {
      Name = "${local.name}_public_route_table"
    }
  )
}

resource "aws_route_table_association" "public_route_table_associations" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}


# Private Route Table and Route Table Associations

resource "aws_route_table" "private_route_tables" {
  for_each = aws_nat_gateway.nat_gateways
  vpc_id   = aws_vpc.cluster_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = merge(
    local.tags,
    {
      Name = "${local.name}_private_route_table_${each.key}"
    }
  )
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_tables[each.key].id

}

