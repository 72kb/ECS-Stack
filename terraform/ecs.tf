# Create ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "${local.prefix}-my-ecs-cluster" # Replace with your desired ECS cluster name

  tags = {
    Name = "${local.prefix}-cluster"
  }
}

resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "${local.prefix}-port-app-definition"
  requires_compatibilities = ["FARGATE"]
  cpu = 512
  memory = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      "name" : "portfolio-app",
      "image" : "497805377012.dkr.ecr.us-east-1.amazonaws.com/porfolio-app-72kb-github-actions:9cc7f26c482c73a1883a4e2e5ffb47ec9985741d",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/my-port-app",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs-task"
        }
      },
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
        }
      ],
      "essential" : true,
      "networkMode" : "awsvpc",
      "cpu" : 512,
      "memory" : 1024

    }
  ])
}

resource "aws_ecs_service" "my_service" {
  name            = "${local.prefix}-my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  depends_on = [
    aws_cloudwatch_log_group.ecs_log_group,
    aws_cloudwatch_log_stream.ecs_log_stream,
    aws_cloudwatch_log_subscription_filter.ecs_log_filter,
  ]

  network_configuration {
    subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.service_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    container_name   = "portfolio-app"
    container_port   = 3000
  }
}

resource "aws_security_group" "service_security_group" {
  name        = "${local.prefix}-my-ecs-service-security-group"
  description = "Security group for ecs service"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.lb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
