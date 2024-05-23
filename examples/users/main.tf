provider "aws" {
    region              = "eu-central-1"
    default_tags {
        tags = {
            Name = "User"
        }
    }
}

terraform {
    required_version = ">= 1.1.5"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.60.0"
        }
    }
}

data "aws_iam_policy_document" "AssumeRole" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${module.iam_role.arn}"] 
  }
}

module "iam_user" {
    source = "../modules//iam/user"
    name = "yogesh"
    enable_programmetic_access = true
    add_direct_policy = true
    policy = data.aws_iam_policy_document.AssumeRole.json
}

output "access-key" {
    value = module.iam_user.access-key
}

output "secret-key" {
    sensitive = true
    value = module.iam_user.secret-key
}