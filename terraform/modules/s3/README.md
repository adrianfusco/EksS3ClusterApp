# Complete S3 bucket with specific allow policies

The configuration provided in this directory creates a S3 bucket with the following capabillities:

- List all the bucket for the user provided in the Principal directive.
- Push objects to the bucket allowing the user provided in the Principal directive.

It loads the tomplate [s3-bucket-policy.json.tpl](../../templates/aws-iam-policies/s3-bucket-policy.json.tpl).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ TF_VAR_bucket_name=BUCKET_NAME TF_VAR_user_arn=arn:aws:iam::USER_ID:user/user terraform apply
```

Note:

- It can create resources which cost money. Run `terraform destroy` when you don't need these resources.
- Depending of the module and the dependencies created maybe some things can't be deleted using `terraform destroy`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.66.1 |

## Modules

| Name | Version |
|------|--------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
