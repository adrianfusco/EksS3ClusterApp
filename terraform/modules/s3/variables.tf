variable "bucket_name" {
  type        = string
  description = "Name of the bucket. If provided, the bucket will be created with this name instead of generating the name from the context"
}

variable "user_arn" {
  type        = string
  description = "ARN of the user that will be used to set the Principal directive in the S3 policy"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}
