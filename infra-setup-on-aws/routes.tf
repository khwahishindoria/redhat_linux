resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
      Name = "public-rt"
    }

        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_internet_gateway.prod-igw.id
        }

}

resource "aws_route_table_association" "prod-vpc-RT-ASC" {
    subnet_id = aws_subnet.prod-vpc_subnet1.id
    route_table_id = aws_route_table.public-rt.id
    depends_on = [ aws_route_table.public-rt ]

}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.prod-vpc.id
    tags = {
      Name = "private-rt"
    }

        route {
            cidr_block = "0.0.0.0/0"
            gateway_id = aws_nat_gateway.my-nat.id
        }
    depends_on = [ aws_internet_gateway.prod-igw, aws_vpc.prod-vpc ]
}

resource "aws_route_table_association" "prod-vpc-RT-ASC-private" {
    subnet_id = aws_subnet.prod-vpc_subnet2.id
    route_table_id = aws_route_table.private-rt.id

}
