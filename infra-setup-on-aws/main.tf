provider "aws" {
    region = "us-east-1"
}

## VPC Creation  ##
variable "prod-vpc_cidr" {
    default = "10.0.0.0/16"
}
resource "aws_vpc" "prod-vpc" {
    tags = {
        Name = "PROD-VPC"
    }
    cidr_block = var.prod-vpc_cidr
}
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.prod-vpc.id

}
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "PROD-ELASTIC_IP"
  }
}

resource "aws_nat_gateway" "my-nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.prod-vpc_subnet1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.prod-igw]
}

