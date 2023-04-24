resource "aws_api_gateway_rest_api" "rest_api" {
  name        = var.name
  description = var.description

  body = var.openapi_spec

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = sha256(jsonencode(aws_api_gateway_rest_api.rest_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id        = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  stage_name           = var.stage_name
  xray_tracing_enabled = true
}

resource "aws_api_gateway_method_settings" "trade-data-all" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "ERROR"
  }

  depends_on = [aws_api_gateway_account.region_settings]
}
