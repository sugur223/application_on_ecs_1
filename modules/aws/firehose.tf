# FireLens用のKinesis Data Firehoseを作成します。エラーログ記録の有効化は cloudwatch_logging_options で設定しますが、
# ロググループとログストリームは自動で作成されないため、事前に作成する必要があります。
resource "aws_kinesis_firehose_delivery_stream" "firelens" {
  name        = "inomaso-dev-kinesis-firehose"
  destination = "s3"

  s3_configuration {
    role_arn           = aws_iam_role.firehose.arn
    bucket_arn         = aws_s3_bucket.firelens.arn
    buffer_size        = 1
    buffer_interval    = 60
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = aws_cloudwatch_log_group.firelens.name
      log_stream_name = "kinesis_error"
    }
  }
}