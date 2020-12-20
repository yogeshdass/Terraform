output "vpcid" {
    value = aws_vpc.newvpc.id
}

output "DefaultSecurityGroup" {
    value = aws_default_security_group.default.id
}
output "PrivateSubnets" {
    value = [ for subnet in aws_subnet.PrivateSubnets: "${subnet.id} => ${subnet.cidr_block}" ]
}
output "PublicSubnets" {
    value = [ for subnet in aws_subnet.PublicSubnets: "${subnet.id} => ${subnet.cidr_block}" ]
}
