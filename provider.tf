terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-2"
  shared_credentials_files = ["/Users/omisam/.aws/credentials"]
}