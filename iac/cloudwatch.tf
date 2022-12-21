resource "aws_cloudwatch_log_group" "test-log-group" {
  name = "test-log-group"

  tags = {
    Resource = "Test-LogGroup"
  }
}