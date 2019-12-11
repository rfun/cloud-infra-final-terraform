# kms.tf

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "s3_bucket" {
  deletion_window_in_days = 7
  description             = "Key for S3 encryption"

  policy = <<Policy
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow EC2 Role to use key",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.ec2S3Role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
Policy
}

resource "aws_kms_alias" "s3_bucket" {
  name          = "alias/s3_bucket"
  target_key_id = "${aws_kms_key.s3_bucket.id}"
}
