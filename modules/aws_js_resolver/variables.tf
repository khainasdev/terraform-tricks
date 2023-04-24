variable "api_id" {
  type = string
}

variable "data_source" {
  type = string
}

variable "field" {
  type = string
}

variable "code" {
  type = string
}

variable "type" {
  type    = string
  default = "Query"
  validation {
    condition     = contains(["Query", "Mutation", "Subscription"], var.type)
    error_message = "The type must be one of Query, Mutation, Subscription."
  }
}
