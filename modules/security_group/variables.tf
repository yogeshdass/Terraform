variable "security_group_name" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}

variable "create_security_group" {
    type = bool
    description = "(optional) describe your variable"
    default = false
}

variable "security_group_id" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}

variable "vpc_id" {
    type = string
    description = "(optional) describe your variable"
    default = ""
}

variable "rules" {
    type = list(object({
        rule_type = string
        cidr_blocks = list(string)
        from_port = number
        to_port = number
        protocol = any
    }))
}

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

variable "service" {
    type = string
    description = "service is required to tag the resource"
    default = ""
    validation {
        condition = var.service != ""
        error_message = "Service is required to tag the resource."
    }
}