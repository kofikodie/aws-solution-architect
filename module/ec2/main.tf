resource "aws_instance" "this" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.security_groups
  key_name        = var.key_name
  tags            = var.tags
  user_data       = var.user_data
}
