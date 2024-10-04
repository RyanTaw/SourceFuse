resource "aws_ecs_cluster" "cluster" {
  name = "SourceFuse"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "container" {
  family = "service"
  tags = local.common_tags
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      networkMode = "awsvpc"
      family = "http-server"
      requiresCompatabilities: ["FARGATE"]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }  
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}

resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.container.arn
  desired_count   = 1
  iam_role        = aws_iam_role.iam.arn
  depends_on      = [aws_iam_role_policy.iam]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.load_balancer.arn
    container_name   = "nginx"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}