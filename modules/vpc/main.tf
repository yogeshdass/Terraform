locals {
    service = "vpc"
    mix_subnets = contains(regexall("default",var.vpc_type),"default")
    only_public_subnets = contains(regexall("default",var.vpc_type),"default")?true:contains(regexall("public",var.vpc_type),"public")
    only_private_subnets = contains(regexall("default",var.vpc_type),"default")?true:contains(regexall("private",var.vpc_type),"private")
}

data "aws_availability_zones" "azs" {}

resource "aws_vpc_dhcp_options" "CustomDNSResolvers" {
    count = var.enable_custom_resolvers?1:0
    domain_name_servers = var.custom_resolvers["domain_name_servers"]
    ntp_servers = var.custom_resolvers["ntp_servers"]
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-CustomDNSResolvers"
    }
}

resource "aws_vpc" "newvpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy
    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames =  var.enable_dns_hostnames
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}"
    }
}

resource "aws_vpc_dhcp_options_association" "CustomDNSResolversAttachment" {
    count = var.enable_custom_resolvers?1:0
    vpc_id          = aws_vpc.newvpc.id
    dhcp_options_id = aws_vpc_dhcp_options.CustomDNSResolvers[0].id
}

resource "aws_subnet" "PublicSubnets" {
    count = local.only_public_subnets?length(data.aws_availability_zones.azs.names):0
    vpc_id = aws_vpc.newvpc.id
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    map_public_ip_on_launch = true
    cidr_block = cidrsubnet(aws_vpc.newvpc.cidr_block, var.subnet_cidr_newbits, count.index+1)
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-PublicSubnet${count.index+1}"
    }
}

resource "aws_subnet" "PrivateSubnets" {
    count = local.only_private_subnets?length(data.aws_availability_zones.azs.names):0
    vpc_id = aws_vpc.newvpc.id
    availability_zone = data.aws_availability_zones.azs.names[count.index]
    cidr_block = cidrsubnet(aws_vpc.newvpc.cidr_block, var.subnet_cidr_newbits, count.index+20)
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-PrivateSubnet${count.index+1}"
    }
}

resource "aws_internet_gateway" "igw" {
    count = local.only_public_subnets?1:0
    vpc_id = aws_vpc.newvpc.id
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-InternetGateway"
    }
}

resource "aws_eip" "neip" {
    count = local.mix_subnets?1:0
    vpc = true
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-EIPForNATGateway"
    }
}

resource "aws_nat_gateway" "ngw" {
    count = local.mix_subnets?1:0
    allocation_id = aws_eip.neip[0].id
    subnet_id = aws_subnet.PublicSubnets[0].id
    depends_on = [aws_internet_gateway.igw]
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-NATGateway"
    }
}

resource "aws_route_table" "PublicRouteTable" {
    count = local.only_public_subnets?1:0
    vpc_id = aws_vpc.newvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw[0].id
    }
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-PublicRouteTable"
    }
}

resource "aws_route_table" "PrivateRouteTable" {
    count = local.only_private_subnets?1:0
    vpc_id = aws_vpc.newvpc.id
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-PrivateRouteTable"
    }
}

resource "aws_route" "NATRoute" {
    count = local.mix_subnets?1:0
    route_table_id = aws_route_table.PrivateRouteTable[0].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[0].id
    depends_on = [aws_route_table.PrivateRouteTable]
}

resource "aws_main_route_table_association" "MainRoutetablePrivateSubnet" {
    count = local.mix_subnets?1:0
    vpc_id = aws_vpc.newvpc.id
    route_table_id = aws_route_table.PrivateRouteTable[0].id
}

resource "aws_route_table_association" "PublicSubnetRoutetableAssociation" {
    count = local.only_public_subnets?length(data.aws_availability_zones.azs.names):0
    subnet_id = aws_subnet.PublicSubnets[count.index].id
    route_table_id = aws_route_table.PublicRouteTable[0].id
}

resource "aws_route_table_association" "PrivateSubnetRoutetableAssociation" {
    count = local.only_private_subnets?length(data.aws_availability_zones.azs.names):0
    subnet_id = aws_subnet.PrivateSubnets[count.index].id
    route_table_id = aws_route_table.PrivateRouteTable[0].id
}

# Refer protocol numbers https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
resource "aws_default_security_group" "default" {
    vpc_id = aws_vpc.newvpc.id
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-SecurityGroup"
    }
    ingress {
        description = "Allow All Internal Traffic"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        self = true
    }
    egress {
        description = "Allow All Outbound Traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
/*
data "aws_region" "current" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint#vpc_endpoint_type
resource "aws_vpc_endpoint" "s3" {
    vpc_id       = aws_vpc.newvpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
    route_table_ids = [aws_route_table.PublicRouteTable.id, aws_route_table.PrivateRouteTable.id ]
    vpc_endpoint_type = "Gateway"
    tags = {
        Name = "${var.environment}-${var.project}-${local.service}-VPCEndpointS3"
    }
}
*/