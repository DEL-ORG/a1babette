resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = format("%s-%s-%s-vpc", var.tags["id"], var.tags["environment"], var.tags["project"])
    },
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
