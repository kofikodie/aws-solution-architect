resource "aws_globalaccelerator_accelerator" "global_accelerator" {
  name            = var.name
  ip_address_type = "IPV4"
}

resource "aws_globalaccelerator_listener" "global_accelerator_listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.global_accelerator.id
  port_range {
    from_port = 80
    to_port   = 80
  }
  protocol = "TCP"
}

resource "aws_globalaccelerator_endpoint_group" "global_accelerator_endpoint_group_west" {
  listener_arn                  = aws_globalaccelerator_listener.global_accelerator_listener.id
  health_check_interval_seconds = 30
  health_check_path             = "/"
  health_check_port             = 80
  health_check_protocol         = "HTTP"
  threshold_count               = 3
  endpoint_group_region         = "eu-west-1"

  endpoint_configuration {
    endpoint_id                    = var.ec2_instance_west_instance_id
    weight                         = 100
    client_ip_preservation_enabled = true
  }
}

resource "aws_globalaccelerator_endpoint_group" "global_accelerator_endpoint_group_central" {
  listener_arn                  = aws_globalaccelerator_listener.global_accelerator_listener.id
  health_check_interval_seconds = 30
  health_check_path             = "/"
  health_check_port             = 80
  health_check_protocol         = "HTTP"
  threshold_count               = 3
  endpoint_group_region         = "eu-central-1"

  endpoint_configuration {
    endpoint_id                    = var.ec2_instance_central_instance_id
    weight                         = 100
    client_ip_preservation_enabled = true
  }
}
