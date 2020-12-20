resource "aws_iam_group" "g1"{
    name = var.name
}

resource "aws_iam_group_policy" "aap" {
  name  = "${var.name}_access_policy"
  group = aws_iam_group.g1.name
  policy = var.policy
}