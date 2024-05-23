provider "aws" {
    region              = "eu-central-1"

    default_tags {
        tags = {
            Name = "Tech Role"
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


data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
    name = "CloudWatchAgentServerPolicy"
}
data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
    name = "AmazonSSMManagedInstanceCore"
}
data "aws_iam_policy" "AmazonEC2ReadOnlyAccess" {
    name = "AmazonEC2ReadOnlyAccess"
}

module "iam_role" {
    source = "../modules//iam/role"
    name = "ec2role"
    enable_instance_profile = true
    allowed_service_policy = data.aws_iam_policy_document.this.json
    policy_arns =  [
        data.aws_iam_policy.CloudWatchAgentServerPolicy.arn,
        data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn,
        data.aws_iam_policy.AmazonEC2ReadOnlyAccess.arn
    ]
}