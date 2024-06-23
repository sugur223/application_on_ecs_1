# FireLensとKinesis Data Firehoseの障害切り分け用のロググループを作成します。
# また、Kinesis Data Firehose用のログストリームは事前に作成する必要があるので、注意が必要です。
resource "aws_cloudwatch_log_group" "firelens" {
  name = "/ecs/firelens"
  #retention_in_days = 90
}

resource "aws_cloudwatch_log_stream" "kinesis" {
  name           = "kinesis_error"
  log_group_name = aws_cloudwatch_log_group.firelens.name
}