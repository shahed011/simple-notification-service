resource "aws_cloudwatch_log_group" "test-log-group" {
  name = "/aws/lambda/${local.lambda_function_name}"

  tags = {
    Name = "simple-notification-service-lambda-log-group"
  }
}