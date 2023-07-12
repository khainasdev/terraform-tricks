variable "github_thumbprint" {
  type        = string
  description = "The thumbprint of the GitHub certificate"
  default     = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

variable "cicd_devops_role_name" {
  type        = string
  description = "The name of the role that will be assumed by the DevOps pipeline"
  default     = "GithubDevOpsRole"
}

variable "devops_aws_users" {
  type        = list(string)
  description = "The names of the AWS users that will be used by the DevOps pipeline"
  default = []
}

variable "infra_repo" {
  type        = string
  description = "The name of the GitHub repository that contains the infrastructure code, e.g. 'my-org/my-infra'"
}
