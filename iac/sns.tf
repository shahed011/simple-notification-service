resource "aws_sns_topic" "notification_service_sns" {
  name = "simple-notification-service-topic"

  tags = {
    Name = "simple-notification-service-sns"
  }
}

resource "aws_sns_topic_subscription" "notification_service_sns_subscription" {
  topic_arn = aws_sns_topic.notification_service_sns.arn
  protocol  = "email"
  endpoint  = "shahed011@hotmail.com"
}