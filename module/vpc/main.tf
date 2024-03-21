resource "aws_vpc" "main" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = var.genarate_ipv6_cidr_block
  tags = {
    Name = var.name
  }
}
resource "aws_subnet" "public_subnets" {
  count = length(var.availability_zones)

  vpc_id                          = aws_vpc.main.id
  availability_zone               = var.availability_zones[count.index]
  cidr_block                      = "10.${var.module_id}.${count.index}.0/24"
  map_public_ip_on_launch         = true
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 4, count.index + 2)
  assign_ipv6_address_on_creation = true
  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = "10.${var.module_id}.${count.index + 2}.0/24"

  tags = {
    Name = "private_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_egress_only_internet_gateway" "eigw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_subnets_association" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

//create a route table for private subnets

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.eigw.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_subnets_association" {
  subnet_id      = aws_subnet.private_subnets[1].id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnets[0].id
  connectivity_type = "public"

  tags = {
    Name = "natgw"
  }
}

resource "aws_route_table" "nat_gw_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }
}

resource "aws_route_table_association" "nat_gw_rt_a" {
  subnet_id = aws_subnet.private_subnets[0].id

  route_table_id = aws_route_table.nat_gw_rt.id
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    protocol   = "-1"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
