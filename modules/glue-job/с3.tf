module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
  bucket = "${var.name}-bucket"
  force_destroy = true
}