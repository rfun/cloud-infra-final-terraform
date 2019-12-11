# s3.tf


resource "aws_s3_bucket" "web_bucket" {
  bucket_prefix = "terraform-cloud-final-test"
  acl           = "private"
  region        = "${var.aws_region}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.s3_bucket.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id      = "main_lifecycle"
    enabled = true

    tags = {
      "rule"      = "main_lifecycle"
      "autoclean" = "true"
    }
    # Move to IA
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    # five years
    expiration {
      days = 1825
    }
  }
}

#
# Note that this policy allows access from the specified role if it's via the VPC endpoint, but
# does NOT deny access based on other criteria. If your account has principals that are allowed
# broad S3 access, they will still be able to read and write the bucket.
#
resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = "${aws_s3_bucket.web_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.ec2S3Role.arn}"
      },
      "Action":[
        "s3:GetObject*",
        "s3:PutObject*",
        "s3:DeleteObject*"
      ],
      "Resource": "${aws_s3_bucket.web_bucket.arn}/*",
      "Condition" : {
        "StringEquals": {
          "aws:sourceVpce": "${aws_vpc_endpoint.s3endpoint.id}"
        }
      }
    }
  ]
}
POLICY
}
