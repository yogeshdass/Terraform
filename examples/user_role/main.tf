provider "aws" {
    region              = "eu-central-1"

    default_tags {
        tags = {
            Name = "User Role"
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
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "AdditionalAccess" {
  statement {
    actions = [
        "secretsmanager:GetSecretValue",
        "logs:DescribeDestinations"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy" "AmazonRDSDataFullAccess" {
    name = "AmazonRDSDataFullAccess"
}
data "aws_iam_policy" "AmazonS3FullAccess" {
    name = "AmazonS3FullAccess"
}
data "aws_iam_policy" "SecretsManagerReadWrite" {
    name = "SecretsManagerReadWrite"
}
data "aws_iam_policy" "AWSKeyManagementServicePowerUser" {
    name = "AWSKeyManagementServicePowerUser"
}

module "iam_role" {
    source = "../modules//iam/role"
    name = "Devrole"
    allowed_service_policy = data.aws_iam_policy_document.AssumeRole.json
    access_policy = data.aws_iam_policy_document.AdditionalAccess.json
    policy_arns =  [
        data.aws_iam_policy.AmazonRDSDataFullAccess.arn,
        data.aws_iam_policy.AmazonS3FullAccess.arn,
        data.aws_iam_policy.SecretsManagerReadWrite.arn,
        data.aws_iam_policy.AWSKeyManagementServicePowerUser.arn
    ]
}