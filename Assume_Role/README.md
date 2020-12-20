# Information

- For Organization Accounts create IAM roles sepreately to Assume Role as OrganizationAccountAccessRole role cannot assume role using terraform.

- profile : it is the profile that we set in ~/.aws/credentials

- For more info check the Aws named profiles

- https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html

- Role_arn should be the arn of new IAM Role in subaccount to assume

"provider":{
    "aws":{
      "region": "us-east-1",
      "profile": "default",
      "assume_role": {
        "role_arn": "arn:aws:iam::5464043131:role/yogeshibs"
      }
    }