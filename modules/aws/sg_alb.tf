# ALB用のセキュリティグループを作成します。インターネットからのHTTP通信を全許可しています。
resource "aws_security_group" "alb" {
  name        = "inomaso-dev-alb-sg"
  description = "inomaso-dev-alb-sg"
  vpc_id      = module.vpc.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "inomaso-dev-alb-sg"
  }
}