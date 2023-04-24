variable "name" {
  type        = string
  description = "The name of the API Gateway resource in AWS"
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the REST API resource in AWS"
}

variable "openapi_spec" {
  type        = string
  description = "The OpenAPI specification of the REST API in JSON / YAML format"
}

variable "stage_name" {
  type        = string
  default     = "dev"
  description = "The name of the API stage"
}

variable "domain_name" {
  type        = string
  description = "The friendly domain name of the API"
}

variable "acm_certificate_arn" {
  type        = string
  description = "The SSL certificate ARN to be used on the API Gateway custom domain name for HTTPS"
}

variable "route53_zone_id" {
  type        = string
  description = "The Route53 zone ID to be used to create the API Gateway custom domain record alias"
}
