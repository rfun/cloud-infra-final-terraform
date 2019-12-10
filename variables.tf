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

variable "db_private_subnet_cidr" {
  description = "DB Subnet Private CIDR"
  default     = "172.20.5.0/24"
}


variable "aws_vpc_id" {
  description = "The AWS VPC"
  default     = "vpc-03b4b54482648a14d"
}

variable "aws_subnet_private_id" {
  description = "The AWS Subnet ID"
  default     = "subnet-0def6faa6a66c2df3"
}

variable "aws_subnet_public_id" {
  description = "AWS subnet public"
  default     = "subnet-0f552cd68da2f5756"
}

variable "aws_subnet_private_id_2" {
  description = "The AWS Subnet ID"
  default     = "subnet-0c56f933f18ecf186"
}

variable "aws_subnet_public_id_2" {
  description = "AWS subnet public"
  default     = "subnet-0ec8a603e79213b7b"
}

variable "aws_key_name" {
  description = "Dunno what this does"
  default     = "aws"
}


variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-west-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "myEcsAutoScaleRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
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


variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}
