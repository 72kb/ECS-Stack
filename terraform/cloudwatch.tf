resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/my-port-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "ecs-task"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

resource "aws_cloudwatch_log_subscription_filter" "ecs_log_filter" {
  name            = "ecs-log-filter"
  log_group_name  = aws_cloudwatch_log_group.ecs_log_group.name
  filter_pattern  = ""
  destination_arn = aws_cloudwatch_log_group.ecs_log_group.arn
}


