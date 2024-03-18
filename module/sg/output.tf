output "bastion_allow_ssh" {
  value = aws_security_group.bastion_allow_ssh.id
}

output "private_ssh" {
  value = aws_security_group.private_ssh.id
}
