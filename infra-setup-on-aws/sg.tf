resource "aws_security_group" "prod-vpc-SG" {
    name = "prod-VPC-Web-SG"
    vpc_id = aws_vpc.prod-vpc.id
    ingress {
        description = "Allow HTTP Traffic"
        from_port = 0
        to_port = 65535
        cidr_blocks = [ "10.0.0.0/16" ]
        protocol = "tcp"
    }

    ingress {
        description = "Allow HTTP Traffic"
        from_port = 80
        to_port = 80
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
    }
    ingress {
        description = "Allow Jenkins Traffic"
        from_port = 8080
        to_port = 8080
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "tcp"
    }

    ingress {
        description = "Allow SSH Traffic"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
    ingress {
        description = "Ingress Incoming"
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }
        ingress {
        description = "icmp"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = [ "10.0.0.0/16" ]

    }
    egress {
        description = "Allow all outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    depends_on = [ aws_vpc.prod-vpc ]

}
