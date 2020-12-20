# Security Group module

- The variables environment, project  and service are manadatory.

USAGE :

```go
module "security_group" {
    source = "./modules/security_group"
    environment= "dev"
    project = "wa"
    service = "fake-service"
    create_security_group = true
    vpc_id = "vpc-06a8a2291ddc494dc"
    security_group_name = "test-ec2"
    rules = [
        {
            rule_type = "ingress"
            cidr_blocks = ["0.0.0.0/0"]
            port = 22
            protocol = "tcp"
        },
        {
            rule_type = "egress"
            cidr_blocks = ["0.0.0.0/0"]
            port = 0
            protocol = -1
        }
    ]  
}
```
