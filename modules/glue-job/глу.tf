locals {
  key = reverse(split("/", var.script_path))[0]  
}

resource "aws_s3_object" "this" {
  bucket = module.s3.s3_bucket_id
  key    = local.key
  source = var.script_path
  source_hash = filemd5(var.script_path)
}

resource "aws_glue_job" "this" {
  name     = var.name
  description = var.description
  role_arn = module.iam.RoleArn
  glue_version = var.glue_version
  worker_type = var.worker_type
  number_of_workers = var.number_of_workers
  max_retries = var.max_retries
  timeout = var.timeout
  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }
  command {
    name = var.command_name
    script_location = "s3://${module.s3.s3_bucket_id}/${local.key}"
  }
}

