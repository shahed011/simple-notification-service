resource "aws_sqs_queue" "service_queue" {
  name                      = "simple-notification-service-queue"
  delay_seconds             = 90
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 300

  tags = {
    Name = "simple-notification-service-sqs"
  }
}