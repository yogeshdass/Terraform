# IAM Group module

USAGE :

```go
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
                "arn:aws:iam::42295:role/terraform"
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
```
