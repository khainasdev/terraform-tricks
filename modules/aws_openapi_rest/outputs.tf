output "api_gateway_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "stage_name" {
  value = aws_api_gateway_stage.rest_api_stage.stage_name
}
