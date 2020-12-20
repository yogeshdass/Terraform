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

variable "bucket_name" {
    type = string
    description = "Bucket name is required"
    default = ""
}

variable "acl" {
    type = string
    description = "ACL default is private"
    default = "private"
    validation {
        condition = ( 
            var.acl == "private"                    ||
            var.acl == "public-read"                ||
            var.acl == "public-read-write"          ||
            var.acl == "aws-exec-read"              ||
            var.acl == "authenticated-read"         ||
            var.acl == "bucket-owner-read"          ||
            var.acl == "bucket-owner-full-control"  ||
            var.acl == "log-delivery-write"  
        )
        error_message = "The ACL must be One of private|public-read|public-read-write|aws-exec-read|authenticated-read|bucket-owner-read|bucket-owner-full-control|log-delivery-write."
    }
}

variable "enable_versioning" {
    type = bool
    default = false
    description = "A boolean flag to enable/disable versioning of objects in the Bucket."
    validation {
        condition = ( 
            var.enable_versioning == true ||
            var.enable_versioning == false
        )
        error_message = "The enable_versioning flag must be Either true or false."
    }
}