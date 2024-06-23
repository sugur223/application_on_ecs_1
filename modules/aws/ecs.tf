# ECS Fargateを作成します。各コードの補足はコード内のコメントに記載
# タスク定義
resource "aws_ecs_task_definition" "task" {
  depends_on = [null_resource.fluentbit]

  family             = "httpd-task"
  task_role_arn      = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_task_exec.arn
  #0.25vCPU
  cpu = "256"
  #0.5GB
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  ## templatefile関数でFluent BitのイメージがプッシュされたECRリポジトリURLを、imageurl変数で引き渡し
  container_definitions = templatefile("httpd/container_definitions.json", {
    imageurl = "${aws_ecr_repository.fluentbit.repository_url}:latest"
  })
}

# クラスター
resource "aws_ecs_cluster" "cluster" {
  name = "httpd-cluster"
}

# サービス
resource "aws_ecs_service" "service" {
  #depends_on = [aws_cloudwatch_log_group.firelens]

  name             = "httpd-service"
  cluster          = aws_ecs_cluster.cluster.arn
  task_definition  = aws_ecs_task_definition.task.arn
  desired_count    = 2
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
    subnets = module.vpc.public_subnets
  }

  ## ALBのターゲットグループに登録する、コンテナ定義のnameとportMappings.containerPortを指定
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "httpd"
    container_port   = 80
  }

  ## デプロイ毎にタスク定義が更新されるため、リソース初回作成時を除き変更を無視
  lifecycle {
    ignore_changes = [task_definition]
  }
}