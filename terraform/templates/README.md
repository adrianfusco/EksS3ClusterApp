# JSON templates for services

## IAM Policies

### S3 Bucket Policy

- [aws-iam-policies/s3-bucket-policy.json.tpl](aws-iam-policies/s3-bucket-policy.json.tpl): this policy allows to list the content of the specified bucket and put objects on it.

#### Parameter required

| Name | Description |
|------|------|
| bucket_name | The policy will be created on this resource |
| user_arn | The ARN of the user we want to give permission |
