output "asg_id" {
  value = aws_autoscaling_group.ecs_asg.id
}

//arn
output "asg_arn" {
  value = aws_autoscaling_group.ecs_asg.arn
}
