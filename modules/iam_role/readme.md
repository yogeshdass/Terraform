# IAM Role module

USAGE :

```go
module "iam_role" {
    source = "../modules/iam_role"
    name = "terraform"
    allowed_service_policy = file("${path.module}/defaultassumerolepolicy.json")
    access_policy = file("${path.module}/defaultaccesspolicy.json")
}
```
