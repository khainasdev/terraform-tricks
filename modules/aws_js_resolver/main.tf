terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50"
    }
  }
}

resource "aws_appsync_function" "function" {
  api_id      = var.api_id
  data_source = var.data_source
  name        = var.field
  code        = var.code

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}

resource "aws_appsync_resolver" "resolver" {
  api_id = var.api_id
  field  = var.field
  type   = var.type
  kind   = "PIPELINE"
  code   = file("${path.module}/basic.js")
  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
  pipeline_config {
    functions = [
      aws_appsync_function.function.function_id
    ]
  }
}
