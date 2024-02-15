resource "aws_vpc" "this" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true

  tags = tomap({
    "Name" = "vpc-${var.name}",
  })
}

resource "aws_subnet" "this_public" {
  count = 2

  availability_zone       = var.azs[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.this.id

  tags = tomap({
    "Name" = "terraform-subnet-public-${count.index}",
  })
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terraform-ig-${var.name}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "terraform-rt-${var.name}"
  }
}

resource "aws_route_table_association" "rt_association" {
  count = 2

  subnet_id      = aws_subnet.this_public.*.id[count.index]
  route_table_id = aws_route_table.rt.id
}
