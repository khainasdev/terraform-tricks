terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.50"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.github_thumbprint]
}

data "aws_iam_policy_document" "devops_assume" {
  statement {
    sid     = "AllowGithubToAssumeRole"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = formatlist("repo:%s:*", [var.infra_repo])
    }
  }

  statement {
    sid     = "AllowDevOpsAndTerraformToAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = formatlist("arn:${local.partition}:iam::${local.account_id}:user/%s", var.devops_aws_users)
      type        = "AWS"
    }
  }

  statement {
    sid     = "AllowRoleToAssumeItself"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = formatlist("arn:${local.partition}:iam::${local.account_id}:role/%s", [var.cicd_devops_role_name])
      type        = "AWS"
    }
  }
}

data "aws_iam_policy" "power_lord" {
  name = "PowerUserAccess"
}

data "aws_iam_policy" "iam_lord" {
  name = "IAMFullAccess"
}

resource "aws_iam_role" "github-devops-role" {
  name                = var.cicd_devops_role_name
  assume_role_policy  = data.aws_iam_policy_document.devops_assume.json
  managed_policy_arns = [data.aws_iam_policy.power_lord.arn, data.aws_iam_policy.iam_lord.arn]
}
