provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = ["XXXXXX"]
}

terraform {
  required_version = "0.12.12"

  backend "s3" {
    bucket         = "neo-terraform-state"
    key            = "neo-sta"
    region         = "eu-west-1"
    dynamodb_table = "neo-terraform-state"
    kms_key_id     = "arn:aws:kms:eu-west-1:XXXXXX:key/ee51172c-e7bd-46ba-a540-fc66baac4caa"
    encrypt        = "true"
    acl            = "bucket-owner-full-control"
  }
}
