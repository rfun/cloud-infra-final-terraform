# database.tf

# 1.) Subnet creation
# 2.) Security group with correct access
# 3.) DB Creation

# For RPO : The database instance logs are backed up to s3 every 5 minutes and hence we have a 5 minute RPO on RDS by default
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html

resource "aws_db_instance" "rds_mysql" {
  # This needs to be 5.5tb, but for testing our deployment:
  allocated_storage = 20


  # Storage needs to be provisioned iops here since gp2 gives a max of 16000 iops
  storage_type   = "gp2"
  engine         = "mysql"
  engine_version = "5.7"
  # This needs to be a bigger instance. db.m5.4xlarge. Again testing purposes
  instance_class = "db.t2.micro"

  name     = "rds_mysql"
  username = "admin"
  # The password should be set through KMS, but avoiding that for simplicity now
  password                    = "admin123"
  parameter_group_name        = "default.mysql5.7"
  db_subnet_group_name        = "${aws_db_subnet_group.rds-private-subnet.name}"
  vpc_security_group_ids      = ["${aws_security_group.db_layer_security_group.id}"]
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true
  skip_final_snapshot         = true
}
