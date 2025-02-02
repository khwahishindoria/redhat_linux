resource "aws_subnet" "prod-vpc_subnet1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
        type = "public-subnet"
        Name = "public-subnet"
    }
    depends_on = [ aws_vpc.prod-vpc ]
}

resource "aws_subnet" "prod-vpc_subnet2" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false
    availability_zone = "us-east-1b"
    tags = {
        type = "private-subnet"
        Name = "private-subnet"
    }
    depends_on = [ aws_vpc.prod-vpc ]
}
