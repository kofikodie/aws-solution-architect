resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1

  launch_template {
    id      = var.ecs_lt_id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
