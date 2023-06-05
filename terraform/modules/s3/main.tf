# Load policy template and replace vars

data "template_file" "iam-s3-bucket-policy-template" {
  template = file("../../templates/aws-iam-policies/s3-bucket-policy.json.tpl")
  vars = {
    bucket_name = var.bucket_name
    user_arn    = var.user_arn
  }
}

# Set provider and config

provider "aws" {
  profile = "default"
  region  = var.region
}

# Create bucket

resource "aws_s3_bucket" "bucket_creation" {
  bucket = var.bucket_name
}

# Create IAM policy

resource "aws_s3_bucket_policy" "bucket_private_policy" {
  depends_on = [
    aws_s3_bucket.bucket_creation
  ]
  bucket = var.bucket_name
  policy = data.template_file.iam-s3-bucket-policy-template.rendered
}
