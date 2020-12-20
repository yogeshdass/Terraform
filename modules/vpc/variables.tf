variable "environment" {
    type = string
    description = "Environment is required to tag the resource"
    default = ""
    validation {
        condition = ( 
            var.environment == "prod"  ||
            var.environment == "qa"    ||
            var.environment == "dev"   ||
            var.environment == "perf"  ||
            var.environment == "stage" ||
            var.environment == "uat"  
        )
        error_message = "The environment must be One of prod|qa|dev|perf|stage|uat."
    }
}

variable "project" {
    type = string
    description = "Project is required to tag the resource"
    default = ""
    validation {
        condition = var.project != ""
        error_message = "Project is required to tag the resource."
    }
}

variable "vpc_cidr_block" {
    type = string
    description = "VPC CIDR Block"
    default = "10.10.0.0/16"
    validation {
        condition = var.vpc_cidr_block != ""
        error_message = "VPC CIDR cannot be null."
    }
}

variable "instance_tenancy" {
    type = string
    description = "A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host"
    default = "default"
    validation {
        condition = ( 
            var.instance_tenancy == "dedicated" ||
            var.instance_tenancy == "host"      ||
            var.instance_tenancy == "default"
        )
        error_message = "The instance_tenancy must be One of default|dedicated|host ."
    }
}

variable "enable_dns_support" {
    type = bool
    description = "A boolean flag to enable/disable DNS support in the VPC."
    default = true
    validation {
        condition = ( 
            var.enable_dns_support == true ||
            var.enable_dns_support == false
        )
        error_message = "The enable_dns_support flag must be Either true or false."
    }
}

variable "enable_dns_hostnames" {
    type = bool
    description = "A boolean flag to enable/disable DNS hostnames in the VPC"
    default = true
    validation {
        condition = ( 
            var.enable_dns_hostnames == true ||
            var.enable_dns_hostnames == false
        )
        error_message = "The enable_dns_hostnames flag must be Either true or false."
    }
}

variable "subnet_cidr_newbits" {
    type = number
    description = "newbits is the number of additional bits with which to extend the prefix of VPC"
    default = 6
    validation {
        condition = var.subnet_cidr_newbits < 16
        error_message = "The subnet_cidr_newbits must be less then 16 ."
    }
}

variable "enable_custom_resolvers" {
    type = bool
    description = "A boolean flag to enable/disable custom resolvers."
    default = false
    validation {
        condition = ( 
            var.enable_custom_resolvers == true ||
            var.enable_custom_resolvers == false
        )
        error_message = "The enable_custom_resolvers flag must be Either true or false."
    }
}

variable "custom_resolvers" {
    type = map(list(string))
    description = "resolvers"
    default = {
        domain_name_servers = ["8.8.8.8", "8.8.4.4"]
        ntp_servers = ["127.0.0.1"]
    }
}

variable "vpc_type" {
    type = string
    description = "This feature enables allows creation of VPC with Public subnets only, Private subnets only and Both Public and Private subnets mix (Default). Recommended is default mix VPC"
    default = "default"
    validation {
        condition = ( 
            var.vpc_type == "default"              ||
            var.vpc_type == "only_public_subnets"  ||
            var.vpc_type == "only_private_subnets"
        )
        error_message = "The vpc_type must be One of default|only_public_subnets|only_private_subnets."
    }
}