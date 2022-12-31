resource "aws_lambda_function" "notification_service_lambda" {
  filename                       = data.archive_file.dummy.output_path
  function_name                  = local.lambda_function_name
  role                           = aws_iam_role.notification_service_lambda_role.arn
  handler                        = "Simple.Notification.Service.Lambda::Simple.Notification.Service.Lambda.Function::FunctionHandlerAsync"
  runtime                        = "dotnet6"
  memory_size                    = 512
  timeout                        = 600
  reserved_concurrent_executions = 2

  lifecycle {
    ignore_changes = [
      filename
    ]
  }

  tags = {
    Name = local.lambda_function_name
  }
}

resource "aws_lambda_event_source_mapping" "notification_service_lambda_source_mapping" {
  event_source_arn = aws_sqs_queue.service_queue.arn
  function_name    = aws_lambda_function.notification_service_lambda.arn
}

data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content  = "Hello World"
    filename = "dummy.txt"
  }
}

resource "aws_iam_role" "notification_service_lambda_role" {
  name = "${local.lambda_function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${local.lambda_function_name}-role"
  }
}

resource "aws_iam_role_policy_attachment" "notification_service_lambda_execution_policy_attachment" {
  role       = aws_iam_role.notification_service_lambda_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy" "notification_service_lambda_permissions_policy" {
  name = "notification_service_lambda_permissions_policy"
  role = aws_iam_role.notification_service_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
        ]
        Effect   = "Allow"
        Resource = [aws_sns_topic.notification_service_sns.arn]
      },
    ]
  })
}