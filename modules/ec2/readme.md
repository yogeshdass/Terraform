# EC2 module

- The variables environment, project  and service are manadatory.

- ami_alias variable can used to select default AMI (centos8, centos7, centos6, ubuntu20, ubuntu18, ubuntu16) or custom AMI. Currently only Mumbai region default AMIs are supported, for adding support for more regions or default AMIs update the os map in modules/main.tf.

- In case of using custom "ami_alias"  set ami ID for custom AMI

- Public key can only be a path to file or public key itself in case of creation of public key

- In case of creating Windows instance set is_windows varible to true and retrive windows password for login

- userdata can be passed in non encoded format.

USAGE :

```go
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
```
