# Create ECR Repository
resource "aws_ecr_repository" "simple-web-app" {
  name                 = "simple-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/simple-web-app"
  retention_in_days = 7
}

# Create Task Definition
resource "aws_ecs_task_definition" "simple-web-app" {
  family                   = "simple-web-app-task"
  container_definitions    = jsonencode([
    {
      name      = "simple-web-app-container"
      image     = "${aws_ecr_repository.simple-web-app.repository_url}:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = "ap-southeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  
  tags = {
    Name        = "simple-web-app-task"
    Environment = "dev"
  }
}
# Create Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
#Create task role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
# Create Task Execution Policy
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecsTaskExecutionPolicy"
  description = "Policy for ECS task execution role"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = aws_ecr_repository.simple-web-app.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecs_log_group.arn}:*"
      }
    ]
  })
}
# Attach Task Execution Policy to Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}
# Create ECS Cluster
resource "aws_ecs_cluster" "simple-web-app-cluster" {
  name = "simple-web-app-cluster"
  
  tags = {
    Name        = "simple-web-app-cluster"
    Environment = "dev"
  }
}
# Create ECS Service
resource "aws_ecs_service" "simple-web-app-service" {
  name            = "simple-web-app-service"
  cluster         = aws_ecs_cluster.simple-web-app-cluster.id
  task_definition = aws_ecs_task_definition.simple-web-app.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = true
  }
  
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "simple-web-app-container"
    container_port   = 80
  }
  
  tags = {
    Name        = "simple-web-app-service"
    Environment = "dev"
  }
}