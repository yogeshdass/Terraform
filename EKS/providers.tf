#
# Provider Configuration
#

provider "aws" {
  region = "us-west-2"
  access_key = "AKIAIJXFQDIDZ6WZAIBQ"
  secret_key = "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"
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}
