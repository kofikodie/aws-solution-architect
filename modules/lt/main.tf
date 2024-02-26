resource "aws_launch_template" "ecs_launch_config" {
  name_prefix   = var.name
  image_id      = var.image_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.sg_id]

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  user_data = filebase64("${path.module}/user_data.sh")
}
