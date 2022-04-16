terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configuring aws provider using shared creds file
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "ravi_terraform"
  region                   = "us-west-2"
}