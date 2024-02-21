output "sns_topic_arn" {
  value       = aws_sns_topic.saa_c03_sns.arn
  description = "The ARN of the SNS topic"
}
