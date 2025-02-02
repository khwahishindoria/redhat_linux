resource "aws_security_group" "prod-vpc-SG" {
    name = "prod-VPC-Web-SG"
    vpc_id = aws_vpc.prod-vpc.id

    dynamic "ingress" {
      for_each = var.ingress_rules
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = [ "10.0.0.0/16" ]
      }
    }

    dynamic "egress" {
        for_each = var.egress_rules
        content {
          from_port = egress.value
          to_port = egress.value
          protocol = "-1"
          cidr_blocks = [ "0.0.0.0/0" ]
        }
      
    }

}
