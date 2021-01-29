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

resource "random_pet" "pet_name" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${random_pet.pet_name.id}_bucket"
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
  name        = "${random_pet.pet_name.id}_policy"
  description = "My test policy"

  policy = data.aws_iam_policy_document.example.json

}
resource "aws_iam_user" "new_user" {
  name = "new_user"
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.new_user.name
  policy_arn = aws_iam_policy.policy.arn
}
