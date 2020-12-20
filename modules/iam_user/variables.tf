variable "name" {
    type = string
    description = "Name is required"
    default = ""
}

variable "add_to_groups" {
    type = bool
    description = "A boolean flag to enable/disable adding user to groups"
    default = false
    validation {
        condition = ( 
            var.add_to_groups == true ||
            var.add_to_groups == false
        )
        error_message = "The add_to_groups flag must be Either true or false."
    }
}

variable "add_direct_policy" {
    type = bool
    description = "A boolean flag to enable/disable adding policies for a user instead of adding to a group"
    default = false
    validation {
        condition = ( 
            var.add_direct_policy == true ||
            var.add_direct_policy == false
        )
        error_message = "The add_to_groups flag must be Either true or false."
    }
}

variable "policy" {
    type = string
    description = "Policy is required"
    default = ""
}

variable "groups" {
    type = list(string)
    description = "List of groups to which user needs to be added"
    default = []
}

variable "enable_programmetic_access" {
    type = bool
    description = "A boolean flag to enable/disable programmetic access"
    default = false
    validation {
        condition = ( 
            var.enable_programmetic_access == true ||
            var.enable_programmetic_access == false
        )
        error_message = "The enable_programmetic_access flag must be Either true or false."
    }
}

variable "enable_console_access" {
    type = bool
    description = "A boolean flag to enable/disable AWS console access"
    default = false
    validation {
        condition = ( 
            var.enable_console_access == true ||
            var.enable_console_access == false
        )
        error_message = "The enable_console_access flag must be Either true or false."
    }
}

variable "upload_ssh_public_key" {
    type = bool
    description = "A boolean flag to enable/disable upload SSH Public key feature"
    default = false
    validation {
        condition = ( 
            var.upload_ssh_public_key == true ||
            var.upload_ssh_public_key == false
        )
        error_message = "The upload_ssh_public_key flag must be Either true or false."
    }
}

variable "public_key" {
    type = string
    description = "Upload SSH public key in RSA format"
    default = ""
}