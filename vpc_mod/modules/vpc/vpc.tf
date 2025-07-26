resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tuai-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tuai-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.public_sub_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.public_subnet_az[index(var.public_sub_cidr, each.value)]
  map_public_ip_on_launch = true

  tags = {
    Name = "tuai-public-${index(var.public_sub_cidr, each.value)}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each          = toset(var.priv_sub_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.private_subnet_az[index(var.priv_sub_cidr, each.value)]

  tags = {
    Name = "tuai-private-${index(var.priv_sub_cidr, each.value)}"
  }
}

locals {
  public_subnet_by_az = { for s in aws_subnet.public : s.availability_zone => s.cidr_block }
}

# NAT Gateway Setup in each public subnet
resource "aws_eip" "nat_eip" {
  for_each   = aws_subnet.public
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "tuai-nat-${each.key}"
  }
}

# Public Route Table (routes to Internet Gateway)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tuai-public-rt"
  }
}

resource "aws_route" "public_rt_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


# Private Route Tables (routes outbound via NAT Gateway)
resource "aws_route_table" "private_rt" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "tuai-private-rt-${each.key}"
  }
}

resource "aws_route" "private_rt_route" {
  for_each               = aws_subnet.private
  route_table_id         = aws_route_table.private_rt[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[local.public_subnet_by_az[each.value.availability_zone]].id
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
}
