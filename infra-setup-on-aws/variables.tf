variable "ec2-instance-names" {
  type = set(string)
  default = [ "redhat-client01", "redhat-client02" ]
}

variable "ingress_rules" {
  default = [ 80, 22 ]
  type = list(number)
}

variable "egress_rules" {
  default = [ 0 ]
  type = list(number)  
}

output "redhatserver-public-ip" {
  value = aws_instance.redhat-server.public_ip
}

output "master-01-privateip" {
  value = aws_instance.redhat-server.private_ip
}

output "worker-nodes-private-ip" {

  value = [ for i in aws_instance.redhat-client: i.private_ip ]
}

