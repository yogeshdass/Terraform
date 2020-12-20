terraform {
    backend "s3" {
        bucket = "terraform-states"
        region = "ap-south-1"
        profile = "terraform"
        key = "prod/terraform.tfstate"
        role_arn = "arn:aws:iam::424503:role/terraform"
        session_name = "terraform"
    }
}
provider "aws" {
    region = "ap-south-1"
    profile = "terraform"
    assume_role {
      role_arn = "arn:aws:iam::424503:role/terraform"
    }
}
/*


module "ec2" {
    source = "./modules/ec2"
    number_of_instances = 2
    environment= "dev"
    project = "wa"
    service = "fake-service"
    ami_alias = "custom"
    ami = "ami-048bb32b1fb7c36b7"
    instance_shutdown_behavior = "terminate"
    instance_type = "t2.nano"
    key_pair_name = "ykey"
    create_key_pair = true
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK3i8lDIr+YfgBGPvuD21hr73k1vh+/yIxQlOYVaBZlVrq7wQRmewsG6+xsY/lx3lQJli4rwooP8jlO33+jQD+SJYHMrsHcG3gHJUut4mXWymtxehnhti9FTowx1ZUhDlz7XvR5vxw3LAsrqOD6ZvdjzUXURzR5opsUebYWCSB8WuFSPfI7ogBjMbXfHxkg6tB4b6Nr5h+VL500b/PgA8MWQdvU82slSnu9hCH8P9q6DLD7juhKAIrQzrGzhWrB1YSB9nPtoRUE8T2FuodPnjpc8Buw0+kEO1LqSXJ2qRaYOI2Q18XvieHNuCoJGAN8f0qoV2LHLU6pIeEiSB+YlHb"
    security_groups = [module.security_group.id]
    subnet_id = "subnet-0e14d525b680fa738"
    associate_public_ip_address = true
    user_data = "${file("install.sh")}"
}

output "ec2-public_ips" {
    value = module.ec2.public_ips
}

output "ec2-private_ips" {
    value = module.ec2.private_ips
}
*/

module "vpc" {
    source = "./modules/vpc"
    environment= "prod"
    project = "ytest"
    vpc_cidr_block = "10.10.0.0/16"
}

output "VPC-ID" {
    value = module.vpc.vpcid
}
output "Private-Subnets" {
    value = module.vpc.PrivateSubnets
}
output "Public-Subnets" {
    value = module.vpc.PublicSubnets
}
output "Default-Security-Group" {
    value = module.vpc.DefaultSecurityGroup
}
/*
module "iam_group" {
    source = "./modules/iam_group"
    name = "terraformroleassume"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::424503:role/terraform"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF

}

output "IAM-Group-ARN" {
    value = module.iam_group.arn
}


*/