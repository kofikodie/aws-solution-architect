data "aws_vpc" "saa_vpc" {
  default = true
}

resource "aws_subnet" "sub_a" {
  vpc_id            = data.aws_vpc.saa_vpc.id
  cidr_block        = "172.31.0.0/17"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "saa_subnet_a"
  }
}

resource "aws_subnet" "sub_b" {
  vpc_id            = data.aws_vpc.saa_vpc.id
  cidr_block        = "172.31.128.0/17"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "saa_subnet_b"
  }
}

resource "aws_internet_gateway" "ig_saa" {
  vpc_id = data.aws_vpc.saa_vpc.id

  tags = {
    Name = "saa_ig"
  }
}

resource "aws_route_table" "saa_route_table" {
  vpc_id = data.aws_vpc.saa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_saa.id
  }
}

resource "aws_route_table_association" "saa_route_table_association_a" {
  subnet_id      = aws_subnet.sub_a.id
  route_table_id = aws_route_table.saa_route_table.id
}

resource "aws_route_table_association" "saa_route_table_association_b" {
  subnet_id      = aws_subnet.sub_b.id
  route_table_id = aws_route_table.saa_route_table.id
}
