output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_eu_west_1a_subnet_id" {
  value = aws_subnet.public-eu-west-1a.id
}

output "public_eu_west_1b_subnet_id" {
  value = aws_subnet.public-eu-west-1b.id
}

output "private_eu_west_1a_subnet_id" {
  value = aws_subnet.private-eu-west-1a.id
}

output "private_eu_west_1b_subnet_id" {
  value = aws_subnet.private-eu-west-1b.id
}
