output "sg_ecs_id" {
  value = aws_security_group.ecs_tasks.id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}