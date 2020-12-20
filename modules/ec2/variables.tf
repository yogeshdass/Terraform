variable "number_of_instances" {
    type = number
    description = "Number of similar instances to create"
    default = 1
}

variable "ami_alias" {
    type = string
    description = "Use pre-defined AMIs of AWS by using aliases or mention custom for using your own AMI and set ami variable with custom AMI ID"
    default = "centos7"
    validation {
        condition = ( 
            var.ami_alias == "centos8"  ||
            var.ami_alias == "centos7"  ||
            var.ami_alias == "centos6"  ||
            var.ami_alias == "ubuntu20" ||
            var.ami_alias == "ubuntu18" ||
            var.ami_alias == "ubuntu16" ||
            var.ami_alias == "custom"
        )
        error_message = "The ami_alias must be One of centos8|centos7|centos6|ubuntu20|ubuntu18|ubuntu16|custom."
    }
}

variable "ami" {
    type = string
    description = "Custom AMI ID to use in case of custom ami_alias"
    default = ""
}

variable "enable_termination_protection" {
    type = bool
    description = "A boolean flag to enable/disable termination protection in  prevents accidental deletion of instance"
    default = false
    validation {
        condition = ( 
            var.enable_termination_protection == true ||
            var.enable_termination_protection == false
        )
        error_message = "The enable_termination_protection flag must be Either true or false."
    }
}

variable "instance_shutdown_behavior" {
    type = string
    description = "Whether to stop or terminate instance on shutdown"
    default = "stop"
    validation {
        condition = ( 
            var.instance_shutdown_behavior == "stop" ||
            var.instance_shutdown_behavior == "terminate"
        )
        error_message = "The instance_shutdown_behavior  must be Either stop or terminate."
    }
}

variable "instance_type" {
    type = string
    description = "Instance type"
    default = ""
    validation {
        condition = var.instance_type != ""
        error_message = "Instance type is required."
    }
}

variable "key_pair_name" {
    type = string
    description = "name of the key_pair"
    validation {
        condition = var.key_pair_name != ""
        error_message = "Name of the key_pair is required."
    }
}

variable "create_key_pair" {
    type = bool
    description = "A boolean flag to enable/disable creation of key pair"
    default = false
    validation {
        condition = ( 
            var.create_key_pair == true ||
            var.create_key_pair == false
        )
        error_message = "The create_key_pair flag must be Either true or false."
    }
}

variable "public_key" {
    type = string
    description = "Need Public key to create key pair only"
    default = ""
}

variable "security_groups" {
    type = list(string)
    description = "Security groups to attach to the new EC2 instances"
}

variable "subnet_id" {
    type = string
    description = "Subnet ID in which instance(s) will be launched"
    validation {
        condition = var.subnet_id != ""
        error_message = "Subnet_id is required."
    }
}

variable "associate_public_ip_address" {
    type = bool
    description = "A boolean flag to enable/disable association of public ip address"
    default = false
    validation {
        condition = ( 
            var.associate_public_ip_address == true ||
            var.associate_public_ip_address == false
        )
        error_message = "The associate_public_ip_address flag must be Either true or false."
    }
}

variable "source_dest_check" {
    type = bool
    description = "A boolean flag to enable/disable source_dest_check"
    default = true
    validation {
        condition = ( 
            var.source_dest_check == true ||
            var.source_dest_check == false
        )
        error_message = "The source_dest_check flag must be Either true or false."
    }
}

variable "user_data" {
    type = string
    description = "User data in non base64 encoded format"
    default = ""
}

variable "iam_instance_profile" {
    type = string
    description = "IAM instance profile to attach to the EC2 instance"
    default = ""
}

variable "volume_size" {
    type = number
    description = "Disk size in (GB) "
    default = 10
}

variable "volume_type" {
    type = string
    description = "Volume type "
    default = "gp2"
}

variable "delete_volume_on_termination" {
    type = bool
    description = "A boolean flag to enable/disable delete volume on termination of ec2"
    default = true
    validation {
        condition = ( 
            var.delete_volume_on_termination == true ||
            var.delete_volume_on_termination == false
        )
        error_message = "The delete_volume_on_termination flag must be Either true or false."
    }
}

variable "enable_hibernation" {
    type = bool
    description = "A boolean flag to enable/disable enable hibernation feature in ec2"
    default = false
    validation {
        condition = ( 
            var.enable_hibernation == true ||
            var.enable_hibernation == false
        )
        error_message = "The enable_hibernation flag must be Either true or false."
    }
}

variable "is_windows" {
    type = bool
    description = "A boolean flag to enable/disable windows platfrom related features"
    default = false
    validation {
        condition = ( 
            var.is_windows == true ||
            var.is_windows == false
        )
        error_message = "The is_windows flag must be Either true or false."
    }
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