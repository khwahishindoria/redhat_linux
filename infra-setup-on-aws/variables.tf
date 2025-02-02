variable "ec2-instance-names" {
  type = set(string)
  default = [ "worker-01", "worker-02" ]
}


output "prod-bastion-public-ip" {
  value = aws_instance.prod-bastion.public_ip
}

output "master-01-privateip" {
  value = aws_instance.master-node.private_ip
}

output "worker-nodes-private-ip" {

  value = [ for i in aws_instance.worker-nodes: i.private_ip ]
}

output "load_balancer-dns" {
  value = aws_lb.prod-alb.dns_name
}
