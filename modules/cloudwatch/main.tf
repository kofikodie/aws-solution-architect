resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "ec2-cpu-utilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["arn:aws:automate:${var.region}:ec2:terminate"]
}
