variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Common tags to be applied to resources"
  default = {
    "id"             = "2014"
    "owner"          = "babette 2024"
    "teams"          = "a1 session"
    "environment"    = "dev"
    "project"        = "del"
    "create_by"      = "Terraform a1babette"
    "cloud_provider" = "aws"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
