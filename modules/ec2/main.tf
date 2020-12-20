data "aws_region" "current" {}

locals {
    os = {
        ap-south-1 = {
            centos8 = {
                ami = "ami-056940cb2a7bb6d71"
                release_tag = "8.2.2004"
                username = "centos"
            }
            centos7 = {
                ami = "ami-0dd861ee19fd50a16"
                release_tag = "7.8.2003"
                username = "centos"
            }
            centos6 = {
                ami = "ami-3d9ec952"
                release_tag = "1801_01/6.10"
                username = "centos"
            }
            ubuntu20 = {
                ami = "ami-0cda377a1b884a1bc"
                release_tag = "20.04"
                username = "ubuntu"
            }
            ubuntu18 = {
                ami = "ami-03f0fd1a2ba530e75"
                release_tag = "18.04"
                username = "ubuntu"
            }
            ubuntu16 = {
                ami = "ami-048bb32b1fb7c36b7"
                release_tag = "16.04"
                username = "ubuntu"
            }
            custom = {
                ami = var.ami
                release_tag = "custom"
                username = "ubuntu|centos|ec2_user|root"
            }
        }
    }
}

resource "aws_key_pair" "publicKey" {
    count = var.create_key_pair?1:0
    key_name = var.key_pair_name
    public_key = var.public_key
}
resource "aws_instance" "instances" {
    count = var.number_of_instances
    ami = local.os[data.aws_region.current.name][var.ami_alias].ami
    disable_api_termination = var.enable_termination_protection
    instance_initiated_shutdown_behavior =  var.instance_shutdown_behavior
    instance_type = var.instance_type
    key_name = var.key_pair_name
    vpc_security_group_ids = var.security_groups
    subnet_id = var.subnet_id
    associate_public_ip_address = var.associate_public_ip_address
    source_dest_check = var.source_dest_check
    user_data = var.user_data
    iam_instance_profile = var.iam_instance_profile
    root_block_device {
        delete_on_termination = var.delete_volume_on_termination
        volume_size = var.volume_size
        volume_type = var.volume_type
    }
    hibernation = var.enable_hibernation
    get_password_data = var.is_windows
    tags = {
        Name = "${var.environment}-${var.project}-${var.service}"
    }
}
