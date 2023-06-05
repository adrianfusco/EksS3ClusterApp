{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Principal": {
        "AWS": "${user_arn}"
      },
      "Resource": "arn:aws:s3:::${bucket_name}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Principal": {
        "AWS": "${user_arn}"
      },
      "Resource": "arn:aws:s3:::${bucket_name}/*"
    }
  ]
}
