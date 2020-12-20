output "public_ips" {
    value = [for instance in aws_instance.instances.*.public_ip : "ssh -i ${var.key_pair_name}.pem ${local.os[data.aws_region.current.name][var.ami_alias].username}@${instance}" ]
}

output "private_ips" {
    value = [for instance in aws_instance.instances.*.private_ip : "ssh -i ${var.key_pair_name}.pem ${local.os[data.aws_region.current.name][var.ami_alias].username}@${instance}" ]
}

output "passwd" {
  value = "${var.is_windows?rsadecrypt(aws_instance.instances.*.password_data,file("./private-key.pem")):""}"
}
