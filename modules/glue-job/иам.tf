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

resource "aws_iam_policy" "additional_json" {
  count = var.attach_policy_json ? 1 : 0
  name   = "${var.name}-additional_policies"
  policy = var.policy_json
}

module "iam" {
    source = "git::https://github.com/yogeshdass/terraform//modules/iam/role"
    name = "${var.name}-role"
    allowed_service_policy = data.aws_iam_policy_document.AssumeRole.json
    access_policy = data.aws_iam_policy_document.CustomInlinePermissions.json
    policy_arns = var.attach_policy_json ? [data.aws_iam_policy.AWSGlueServiceRole.arn, aws_iam_policy.additional_json[0].arn] : [data.aws_iam_policy.AWSGlueServiceRole.arn]
}
