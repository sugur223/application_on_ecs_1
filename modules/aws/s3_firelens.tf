# Kinesis Data Firehoseから配信するためのS3バケットを作成します。
resource "aws_s3_bucket" "firelens" {
  ## bucketを指定しないと[terraform-xxxx]というバケット名になる
  bucket = "inomaso-dev-firelens"
  acl    = "private"

  ## S3バケットにオブジェクトがあっても削除
  ## 本番はfalse推奨
  force_destroy = true
  ## SSE-S3で暗号化
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "Delete-After-90days"
    enabled = true

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket_public_access_block" "firelens" {
  bucket = aws_s3_bucket.firelens.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}