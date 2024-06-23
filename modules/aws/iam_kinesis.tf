# Kinesis Data Firehoseから、S3バケットとCloudWatch Logsへの配信するためのIAMロールを作成します。IAMロールの権限は最低限の Actions のみ許可しています。
# また特定のS3バケットとCloudWatch Logsにのみ Actions を許可るすため Resources も制限しています。
# firehose用IAMロール作成
resource "aws_iam_role" "firehose" {
  name               = "inomaso-dev-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume.json
}

# firehose用IAMロールを引き受けるための信頼関係を設定
data "aws_iam_policy_document" "firehose_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

# firehose用IAMロール用のIAMポリシーを作成し、IAMロールにアタッチ
resource "aws_iam_role_policy" "firehose" {
  name   = "inomaso-dev-firehose-role-policy"
  role   = aws_iam_role.firehose.id
  policy = data.aws_iam_policy_document.firehose_access.json
}

# firehose用IAMロールのIAMポリシーJSON
data "aws_iam_policy_document" "firehose_access" {
  version = "2012-10-17"

  statement {
    sid = "S3Access"

    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.firelens.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.firelens.bucket}/*",
    ]
  }
  statement {
    sid = "CloudWatchLogsDeliveryErrorLogging"

    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.firelens.arn}:log-stream:*"
    ]
  }
}