resource "aws_security_group" "sg" {
    count = var.create_security_group?1:0
    name = var.security_group_name
    revoke_rules_on_delete = true
    vpc_id = var.vpc_id
    tags =  {
        Name = "${var.environment}-${var.project}-${var.service}-securityGroup"
    }
}

resource "aws_security_group_rule" "rules" {
    for_each  = { for rule in var.rules: rule.from_port => rule}

    type              = each.value.rule_type
    cidr_blocks       = each.value.cidr_blocks
    from_port         = each.value.from_port
    protocol          = each.value.protocol
    security_group_id = var.create_security_group? aws_security_group.sg[0].id: var.security_group_id
    to_port           = each.value.to_port
}