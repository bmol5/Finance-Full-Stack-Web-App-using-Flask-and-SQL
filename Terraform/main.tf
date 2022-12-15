provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"

}

# Cluster
resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "financeapp-cluster"
  tags = {
    Name = "finance-ecs"
  }
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/finance-logs"

  tags = {
    Application = "finance-app"
  }
}

# Task Definition

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "finance-task"

  container_definitions = <<EOF
  [
    {
        "name": "finance-container",
        "image": "suborna/finance_app:v2",
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/finance-logs",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "portMappings": [
          {
            "containerPort": 5000
          }
        ]
    },
    {
      "name": "datadog-agent",
      "image": "datadog/agent:latest",
      "environment": [
        {
          "name": "DD_API_KEY",
          "value": "f14a419f4854b57b3f626865c2ae12763f2cfa31"
        },
        {
          "name": "ECS_FARGATE",
          "value": "true"
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::309482056010:role/ECS_task_role"
  task_role_arn            = "arn:aws:iam::309482056010:role/ECS_task_role"

}

# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "finance-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.ingress_app.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.finance-app.arn
    container_name   = "finance-container"
    container_port   = 5000
  }

}
