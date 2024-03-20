resource "aws_security_group" "bastion_allow_ssh" {
  vpc_id      = var.vpc_id
  name        = var.public_ssh_sg_name
  description = "security group for bastion that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_address
  }
  tags = {
    Name = var.public_ssh_sg_name
  }
}

resource "aws_security_group" "http" {
  vpc_id      = var.vpc_id
  name        = var.http_sg_name
  description = "security group for public that allows http and all ingress traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ssh" {
  vpc_id      = var.vpc_id
  name        = var.private_ssh_sg_name
  description = "security group for private that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_allow_ssh.id]
  }
  tags = {
    Name = var.private_ssh_sg_name
  }
}
