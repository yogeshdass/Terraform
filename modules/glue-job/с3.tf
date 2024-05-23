module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
  bucket = replace("${var.name}-bucket", "_", "-") 
  force_destroy = true
}