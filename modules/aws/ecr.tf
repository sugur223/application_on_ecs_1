# ECRを作成し、Fluent Bitのコンテナイメージをプッシュします。

resource "aws_ecr_repository" "fluentbit" {
  name = "inomaso-dev-ecr-fluentbit"
  ## 同じタグを使用した後続イメージのプッシュによるイメージタグの上書き許可
  image_tag_mutability = "MUTABLE"

  ## プッシュ時のイメージスキャン
  image_scanning_configuration {
    scan_on_push = true
  }
}

# AWSアカウント情報取得
data "aws_caller_identity" "my" {}

# terraform apply時にFluent Bitのコンテナイメージプッシュ
resource "null_resource" "fluentbit" {
  ## 認証トークンを取得し、レジストリに対して Docker クライアントを認証
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.my.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com"
  }

  ## Dockerイメージ作成
  provisioner "local-exec" {
    command = "docker build -f fluentbit/Dockerfile -t inomaso-dev-fluentbit ."
  }

  ## ECRリポジトリにイメージをプッシュできるように、イメージにタグ付け
  provisioner "local-exec" {
    command = "docker tag inomaso-dev-fluentbit:latest ${aws_ecr_repository.fluentbit.repository_url}:latest"
  }

  ## ECRリポジトリにイメージをプッシュ
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.fluentbit.repository_url}:latest"
  }
}