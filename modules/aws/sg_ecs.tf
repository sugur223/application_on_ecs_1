# ECSサービス用のセキュリティグループを作成します。ALBからのHTTP通信のみ許可しています。
resource "aws_security_group" "ecs" {
  name        = "inomaso-dev-ecs-sg"
  description = "inomaso-dev-ecs-sg"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "inomaso-dev-ecs-sg"
  }
}