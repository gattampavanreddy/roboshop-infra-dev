terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.33.0" # Terraform AWS provider version
    }
  }

  backend "s3" {
    bucket = "roboshop-88s-pavan-dev" # this is for S3 bucket
    key    = "roboshop-dev-backend-alb"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true # this is for state locking to prevent concurrent modifications to the state file
  }
}

provider "aws" {
  region = "us-east-1"
}