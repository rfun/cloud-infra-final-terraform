# variables.tf
variable "aws_vpc_cidr" {
  description = "VPC CIDR"
  default     = "172.20.0.0/16"
}

variable "public_subnet_az_a_cidr" {
  description = "Subnet Public CIDR"
  default     = "172.20.11.0/24"
}

variable "public_subnet_az_b_cidr" {
  description = "Subnet Public CIDR"
  default     = "172.20.12.0/24"
}

variable "web_private_subnet_az_a_cidr" {
  description = "Web Subnet Private CIDR"
  default     = "172.20.1.0/24"
}

variable "web_private_subnet_az_b_cidr" {
  description = "Web Subnet Private CIDR"
  default     = "172.20.2.0/24"
}

variable "app_private_subnet_az_a_cidr" {
  description = "App Subnet Private CIDR"
  default     = "172.20.3.0/24"
}

variable "app_private_subnet_az_b_cidr" {
  description = "App Subnet Private CIDR"
  default     = "172.20.4.0/24"
}

variable "db_private_subnet_az_a_cidr" {
  description = "DB Subnet Private CIDR"
  default     = "172.20.5.0/24"
}

variable "db_private_subnet_az_b_cidr" {
  description = "DB Subnet Private CIDR"
  default     = "172.20.6.0/24"
}

variable "aws_key_name" {
  description = "Dunno what this does"
  default     = "aws"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "bradfordhamilton/crystal_blockchain:latest"
}

variable "web_app_port" {
  description = "Default port the application runs on"
  default     = 3000
}

variable "app_tier_port" {
  description = "Port exposed by application layer"
  default     = 3000
}

variable "db_tier_port" {
  description = "Port exposed by database layer"
  default     = 3306
}

variable "health_check_path" {
  default = "/"
}
