output "RoleArn" {
    value = aws_iam_role.role.arn
}

output "RoleName" {
    value = aws_iam_role.role.id
}
output "InstanceProfileArn" {
    value = var.enable_instance_profile?aws_iam_instance_profile.InstanceProfile[0].arn:""
}