resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    acl = var.acl
    force_destroy = true
    versioning {
        enabled = var.enable_versioning
    }
    tags = {
        Name = "${var.environment}-${var.project}-S3-bucket"
    }
}

resource "aws_s3_bucket_public_access_block" "pab" {
    bucket = aws_s3_bucket.bucket.id
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
    restrict_public_buckets = true
}