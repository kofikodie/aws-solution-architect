resource "aws_vpc_peering_connection" "main" {
  vpc_id      = var.primary_vpc_id
  peer_vpc_id = var.secondary_vpc_id
  auto_accept = true
  tags = {
    Name = "main"
  }
}

resource "aws_route" "primary2secondary" {
  route_table_id            = var.primary_main_route_table_id
  destination_cidr_block    = var.secondary_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route" "secondary2primary" {
  route_table_id            = var.secondary_main_route_table_id
  destination_cidr_block    = var.primary_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}
