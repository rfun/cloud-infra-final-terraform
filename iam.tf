# iam.tf

########################
# Groups
########################

resource "aws_iam_group" "sysAdminGroup" {
  name = "system-admin"
}

resource "aws_iam_group_policy_attachment" "admin-attach" {
  group      = "${aws_iam_group.sysAdminGroup.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

resource "aws_iam_group" "dbAdminGroup" {
  name = "db-admin"
}

resource "aws_iam_group_policy_attachment" "database-attach" {
  group      = "${aws_iam_group.dbAdminGroup.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

resource "aws_iam_group" "monitoringGroup" {
  name = "monitoring"
}

resource "aws_iam_group_policy_attachment" "monitoring-attach" {
  group      = "${aws_iam_group.monitoringGroup.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

########################
# Roles
########################


resource "aws_iam_role" "ec2S3Role" {
  name = "EC2toS3IAMRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF


}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2_s3_profile"
  role = "${aws_iam_role.ec2S3Role.name}"
}
resource "aws_iam_role_policy" "ec2_s3_full_access_policy" {
  name = "s3_full_access_policy"
  role = "${aws_iam_role.ec2S3Role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

########################
# Users
########################

# This can output the key file that we will need to download and save. 
resource "aws_iam_access_key" "lb" {
  user = "${aws_iam_user.admin_user_1.name}"
}

resource "aws_iam_user" "admin_user_1" {
  name = "admin_user"
}

# Add user to group

resource "aws_iam_group_membership" "sysAdmins" {
  name = "sysAdmin-group-membership"

  users = [
    "${aws_iam_user.admin_user_1.name}"
  ]

  group = "${aws_iam_group.sysAdminGroup.name}"
}


resource "aws_iam_account_password_policy" "password_policy" {

  max_password_age             = 90
  minimum_password_length      = 8
  password_reuse_prevention    = 3
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_numbers              = true
  require_symbols              = true
}


########################
# MFA - Using modules
########################


module "enforce-mfa" {
  source  = "jeromegamez/enforce-mfa/aws"
  version = "2.0.0"
  groups  = [aws_iam_group.sysAdminGroup.name]
  users   = [aws_iam_user.admin_user_1.name]
}
