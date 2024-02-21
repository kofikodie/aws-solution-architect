resource "aws_sns_topic" "saa_c03_sns" {
  name = "saa-c03-sns"
}

resource "aws_sns_topic_subscription" "saa_c03_sns_email" {
  topic_arn = aws_sns_topic.saa_c03_sns.arn
  protocol  = "email"
  endpoint  = "k.kodieaddo@gmail.com"
}
