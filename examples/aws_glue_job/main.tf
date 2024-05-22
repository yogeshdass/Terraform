provider "aws" {
    region              = "eu-central-1"

    default_tags {
        tags = {
            Name = "Test Role"
        }
    }
}

terraform {
    required_version = ">= 1.1.5"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "5.50.0"
        }
    }
}

module "glue_job" {
  source = "./modules/glue-job"
  name = "ytest"
  script_path = "./transformation.py"
}
