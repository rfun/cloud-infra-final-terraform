# security.tf


/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
  name        = "vpc_nat"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["${var.web_private_subnet_az_a_cidr}", "${var.web_private_subnet_az_b_cidr}"]
  }
  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_vpc_cidr}"]
  }


  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  tags = {
    Name = "NATSG"
  }
}

/*
  Web Load Balancer SG
*/
resource "aws_security_group" "web_elb_sg" {
  name        = "web_elb_sg"
  description = "Allow communications from web elb to the web security group"

  ingress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["${var.web_private_subnet_az_a_cidr}", "${var.web_private_subnet_az_b_cidr}"]
  }

  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  tags = {
    Name = "web tier elb sg"
  }
}

/*
  Web Layer Security Group
*/
resource "aws_security_group" "web_layer_security_group" {
  name        = "web_layer_sg"
  description = "Allow communication between the web layer and the application load balancer"

  ingress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnet_az_a_cidr}", "${var.public_subnet_az_b_cidr}"]
  }

  egress {
    from_port   = var.app_tier_port
    to_port     = var.app_tier_port
    protocol    = "tcp"
    cidr_blocks = ["${var.app_private_subnet_az_a_cidr}", "${var.app_private_subnet_az_b_cidr}"]
  }


  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  tags = {
    Name = "web_layer_security_group"
  }
}


/*
  App Load Balancer SG
*/
resource "aws_security_group" "app_elb_sg" {
  name        = "app_elb_sg"
  description = "Allow communications from app elb to the web security group"

  ingress {
    from_port   = var.app_tier_port
    to_port     = var.app_tier_port
    protocol    = "tcp"
    cidr_blocks = ["${var.web_private_subnet_az_a_cidr}", "${var.web_private_subnet_az_b_cidr}"]
  }

  egress {
    from_port   = var.app_tier_port
    to_port     = var.app_tier_port
    protocol    = "tcp"
    cidr_blocks = ["${var.app_private_subnet_az_a_cidr}", "${var.app_private_subnet_az_b_cidr}"]
  }

  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  tags = {
    Name = "app tier elb sg"
  }
}


/*
  App Layer Security Group
*/
resource "aws_security_group" "app_layer_security_group" {
  name        = "app_layer_sg"
  description = "Allow communication between the app layer and the database layer"

  ingress {
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    protocol    = "tcp"
    cidr_blocks = ["${var.app_private_subnet_az_a_cidr}", "${var.app_private_subnet_az_b_cidr}"]
  }

  # TODO : Define the database ports here
  # egress {
  #   from_port   = var.app_tier_port
  #   to_port     = var.app_tier_port
  #   protocol    = "tcp"
  #   cidr_blocks = ["${var.app_private_subnet_az_a_cidr}", "${var.app_private_subnet_az_b_cidr}"]
  # }


  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  tags = {
    Name = "app_layer_security_group"
  }
}
