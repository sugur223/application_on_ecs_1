# インターネットからのHTTP通信をECSに振り分けるロードバランサーを作成します。
resource "aws_lb" "alb" {
  name               = "inomaso-dev-alb"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  # ALB削除保護無効
  # 本番はtrue推奨
  enable_deletion_protection = false
  security_groups            = [aws_security_group.alb.id]
  subnets                    = module.vpc.public_subnets
}

resource "aws_alb_listener" "alb_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "inomaso-dev-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = 200
  }
}