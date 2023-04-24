data "aws_iam_policy_document" "api_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "api_logging" {
  name = "AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "api_logging" {
  name                = "ApiGatewayLoggingRole"
  assume_role_policy  = data.aws_iam_policy_document.api_assume_policy.json
  managed_policy_arns = [data.aws_iam_policy.api_logging.arn]
}

resource "aws_api_gateway_account" "region_settings" {
  cloudwatch_role_arn = aws_iam_role.api_logging.arn
}
