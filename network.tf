# network.tf

######
# VPC
######
resource "aws_vpc" "test-vpc-for-final" {

  cidr_block           = "${var.aws_vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "terraform-aws-final-project"
  }

}

########################
# Internet Gateway
########################

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"
}


########################
# NAT Gateway
########################


resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "class-final-nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.us-west-2a-public.id}"
  depends_on    = ["aws_internet_gateway.default"]
}



########################
# Public Subnets
########################

resource "aws_subnet" "us-west-2a-public" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.public_subnet_az_a_cidr}"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-west-2a-public" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_route_table_association" "us-west-2a-public" {
  subnet_id      = "${aws_subnet.us-west-2a-public.id}"
  route_table_id = "${aws_route_table.us-west-2a-public.id}"
}


resource "aws_subnet" "us-west-2b-public" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.public_subnet_az_b_cidr}"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Public Subnet 2"
  }
}


resource "aws_route_table_association" "us-west-2b-public" {
  subnet_id      = "${aws_subnet.us-west-2b-public.id}"
  route_table_id = "${aws_route_table.us-west-2a-public.id}"
}



########################
# Private Subnets
########################


/*
  Private Subnet 1 for Web Tier
*/
resource "aws_subnet" "us-west-2a-private-web" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.web_private_subnet_az_a_cidr}"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Private Subnet for web in AZ a"
  }
}

resource "aws_route_table" "us-west-2a-private-web" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.class-final-nat-gw.id}"
  }

  tags = {
    Name = "web-private-1"
  }
}


resource "aws_route_table_association" "us-west-2a-private-web" {
  subnet_id      = "${aws_subnet.us-west-2a-private-web.id}"
  route_table_id = "${aws_route_table.us-west-2a-private-web.id}"
}

/*
  Private Subnet 2 for Web Tier
*/
resource "aws_subnet" "us-west-2b-private-web" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.web_private_subnet_az_b_cidr}"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Private Subnet for web in AZ b"
  }
}

resource "aws_route_table_association" "us-west-2b-private-web" {
  subnet_id      = "${aws_subnet.us-west-2b-private-web.id}"
  route_table_id = "${aws_route_table.us-west-2a-private-web.id}"
}


/*
  Private Subnet 1 for App Tier
*/
resource "aws_subnet" "us-west-2a-private-app" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.app_private_subnet_az_a_cidr}"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Private Subnet for app in AZ a"
  }
}

resource "aws_route_table" "us-west-2a-private-app" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.class-final-nat-gw.id}"
  }

  tags = {
    Name = "app-private-1"
  }
}


resource "aws_route_table_association" "us-west-2a-private-app" {
  subnet_id      = "${aws_subnet.us-west-2a-private-app.id}"
  route_table_id = "${aws_route_table.us-west-2a-private-app.id}"
}

/*
  Private Subnet 2 for App Tier
*/
resource "aws_subnet" "us-west-2b-private-app" {
  vpc_id = "${aws_vpc.test-vpc-for-final.id}"

  cidr_block        = "${var.app_private_subnet_az_b_cidr}"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Private Subnet for app in AZ b"
  }
}

resource "aws_route_table_association" "us-west-2b-private-app" {
  subnet_id      = "${aws_subnet.us-west-2b-private-app.id}"
  route_table_id = "${aws_route_table.us-west-2a-private-app.id}"
}

