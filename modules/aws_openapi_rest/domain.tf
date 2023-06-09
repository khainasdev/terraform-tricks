resource "aws_api_gateway_domain_name" "rest-api" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.acm_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "rest-api" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.rest_api_stage.stage_name
  domain_name = aws_api_gateway_domain_name.rest-api.domain_name
}

resource "aws_route53_record" "rest-api" {
  name    = aws_api_gateway_domain_name.rest-api.domain_name
  type    = "A"
  zone_id = var.route53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.rest-api.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.rest-api.regional_zone_id
  }
}
