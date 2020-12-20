resource "aws_iam_user" "user"{
    name = var.name
    force_destroy = true
}

resource  "aws_iam_user_group_membership" "AddUserToGroup" {
    count = var.add_to_groups?1:0
    user = aws_iam_user.user.name
    groups = var.groups
}

resource "aws_iam_user_policy" "policy" {
    count = var.add_direct_policy?1:0
    user = aws_iam_user.user.name
    policy = var.policy
}
resource "aws_iam_user_ssh_key" "user" {
    count = var.upload_ssh_public_key?1:0
    username   = aws_iam_user.user.name
    encoding   = "SSH"
    public_key = var.public_key
}

resource "aws_iam_access_key" "AccessKeys" {
    count = var.enable_programmetic_access?1:0
    user = aws_iam_user.user.name
}

data "local_file" "gpg" {
    count = var.enable_console_access?1:0
    filename = "${path.module}/encoded-public-gpg-key.gpg"
}

resource "aws_iam_user_login_profile" "consoleaccess" {
    count = var.enable_console_access?1:0
    user = aws_iam_user.user.name
    password_reset_required = true
    pgp_key = data.local_file.gpg[0].content_base64
}