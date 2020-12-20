output "name" {
    value = aws_iam_user.user.name
}

output "encrypted-password" {
    value = "${var.enable_console_access? aws_iam_user_login_profile.consoleaccess[0].encrypted_password: ""}"
}

output "access-key" {
    value = "${var.enable_programmetic_access? aws_iam_access_key.AccessKeys[0].id: ""}"
}

output "secret-key" {
    value = "${var.enable_programmetic_access? aws_iam_access_key.AccessKeys[0].secret: ""}"
}
