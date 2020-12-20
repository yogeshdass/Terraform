# IAM user module

This module can be used to create users and applying polices on them.
GPG is required when user with console access is created.
The password will be in base64 encoded and signed with gpg key so private gpg key is should be imported before decrytion.

View the user password with below command

```shell
$ terraform output encrypted-password| base64 --decode | gpg --decrypt
```

## Create encoded gpg keypair

Create keypair

```shell
$ gpg --batch --gen-key <<EOF
%no-protection
Key-Type:1
Key-Length:2048
Subkey-Type:1
Subkey-Length:2048
Name-Real: yogesh
Name-Email: yogeshdass@mail.ru
Expire-Date:0
EOF
```

Export public key

```shell
$ gpg --export --output encoded-public-gpg-key.gpg

```

Export private key

```shell
$ gpg --export-secret-keys yogeshdass@mail.ru > encoded-private-gpg-key.gpg
```

Import keys

```shell
$ gpg --import encoded-public-gpg-key.gpg
$ gpg --import encoded-private-gpg-key.gpg
```


**USAGE :

```go
module "iam_user" {
    source = "../modules/iam_user"
    name = "terraform_executor"
    add_direct_policy = true
    enable_programmetic_access = true
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "${module.iam_role.arn}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

output "name" {
    value = module.iam_user.name
}

output "access-key" {
    value = module.iam_user.access-key
}

output "secret-key" {
    value = module.iam_user.secret-key
}
```
