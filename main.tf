terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.24.1"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_s3_bucket" "bucket" {
  bucket = "test-bucket-${uuid()}"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.bucket.arn]
  }
}


resource "aws_iam_policy" "policy" {
  name        = "test_policy_${uuid()}"
  description = "My test policy"

  policy = data.aws_iam_policy_document.example.json

}
resource "aws_iam_user" "new_user" {
  name = "new_user"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  policy_arn = aws_iam_policy.policy.arn
  users      = [aws_iam_user.new_user.name]
}
