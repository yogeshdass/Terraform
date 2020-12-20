# VPC module

This will create VPC with public and private subnets in each availiability zone of a region.

Supported VPC Designs:

- VPC with Public and Private subnets in each avaliability zone of a region (default)

- VPC with Public subnets only in each avaliablility zone of a region

- VPC with Private subnets only in each avaliablility zone of a region

USAGE :

```go
module "vpc" {
    source = "./modules/vpc"
    environment= "dev"
    project = "wa"
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
```
