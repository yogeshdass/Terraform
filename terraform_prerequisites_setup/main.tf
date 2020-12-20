provider "aws" {
    region = "ap-south-1"
    profile = "cdefault"
}

module "s3" {
    source = "../modules/s3"
    environment= "prod"
    project = "ytest"
    bucket_name = "terraform-states"
    enable_versioning = true
}

module "iam_role" {
    source = "../modules/iam_role"
    name = "terraform"
    allowed_service_policy = file("${path.module}/defaultassumerolepolicy.json")
    access_policy = file("${path.module}/defaultaccesspolicy.json")
}

module "iam_user" {
    source = "../modules/iam_user"
    name = "terraform_executor"
    add_direct_policy = true
    enable_programmetic_access = true
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "${module.iam_role.arn}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

output "name" {
    value = module.iam_user.name
}

output "access-key" {
    value = module.iam_user.access-key
}

output "secret-key" {
    value = module.iam_user.secret-key
}

output "IAM-role-ARN" {
    value = module.iam_role.arn
}
