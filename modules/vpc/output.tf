output "subnet_id" {
  value = aws_subnet.this_public.*.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}