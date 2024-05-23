data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "AssumeRole" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "CustomInlinePermissions" {
    statement {
        actions =  [
            "iam:PassRole"
        ]
        resources =  [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.name}-role"
        ]
    }

    statement {
        actions =  [
            "s3:ListBucket",
            "s3:getObject",
            "s3:PutObject"
        ]
        resources =  [
            "${module.s3.s3_bucket_arn}/*"
        ]
    }
}

data "aws_iam_policy" "AWSGlueServiceRole" {
    name = "AWSGlueServiceRole"
}

module "iam" {
    source = "git::https://github.com/yogeshdass/terraform//modules/iam/role"
    name = "${var.name}-role"
    allowed_service_policy = data.aws_iam_policy_document.AssumeRole.json
    access_policy = data.aws_iam_policy_document.CustomInlinePermissions.json
    policy_arns =  [
        data.aws_iam_policy.AWSGlueServiceRole.arn
    ]
}
