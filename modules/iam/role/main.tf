resource "aws_iam_role_policy" "policy" {
    count = var.access_policy != "" ?1:0
    name = "${var.name}"
    role = aws_iam_role.role.id
    policy = var.access_policy
}

resource "aws_iam_role" "role" {
    name = "${var.name}"
    force_detach_policies = true
    assume_role_policy = var.allowed_service_policy
}

resource "aws_iam_role_policy_attachment" "PolicyArns" {
    count = length(var.policy_arns)>0?length(var.policy_arns):0
    role = aws_iam_role.role.id
    policy_arn = var.policy_arns[count.index]
}

resource "aws_iam_instance_profile" "InstanceProfile" {
    count = var.enable_instance_profile?1:0
    name = "${var.name}"
    role = aws_iam_role.role.id
}