resource "aws_flow_log" "main" {
  log_destination          = var.log_destination
  log_destination_type     = var.log_destination_type
  traffic_type             = var.traffic_type
  vpc_id                   = var.vpc_id
  max_aggregation_interval = 60
  iam_role_arn             = var.role_arn

  tags = {
    Name = var.flow_log_name
  }
}
