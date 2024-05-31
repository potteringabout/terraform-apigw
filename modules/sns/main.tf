resource "aws_cloudwatch_event_rule" "proxy_reminder" {
  name        = "${var.name}-running"
  description = "Fires when proxy is still running"

  schedule_expression = "cron(0 9 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.proxy_reminder.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.proxy_reminder.arn
}

resource "aws_sns_topic" "proxy_reminder" {
  # checkov:skip=CKV_AWS_26: "Ensure all data stored in the SNS topic is encrypted"
  name = "${var.name}-reminder"
}

resource "aws_sns_topic_policy" "proxy_reminder" {
  arn    = aws_sns_topic.proxy_reminder.arn
  policy = data.aws_iam_policy_document.proxy_reminder.json
}

data "aws_iam_policy_document" "proxy_reminder" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.proxy_reminder.arn]
  }
}

resource "aws_sns_topic_subscription" "proxy_reminder" {
  topic_arn = aws_sns_topic.proxy_reminder.arn
  protocol  = "sms"
  endpoint  = var.sms_number
}
