terraform {
  cloud {
    workspaces {
      name = "learn-terraform-aws-iam-policy"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.0"
    }
  }
  required_version = "~> 1.2.0"
}
