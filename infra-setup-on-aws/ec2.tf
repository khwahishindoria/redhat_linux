resource "aws_key_pair" "prod-keypair" {
    key_name = "prod_keypair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_network_interface" "ni-prod-bastion" {
  subnet_id   = aws_subnet.prod-vpc_subnet1.id
  private_ips = ["10.0.0.101"]
  security_groups = [ aws_security_group.prod-vpc-SG.id ]
}

resource "aws_network_interface" "ni-master-node" {
  subnet_id   = aws_subnet.prod-vpc_subnet2.id
  private_ips = ["10.0.1.20"]
  security_groups = [ aws_security_group.prod-vpc-SG.id ]
}

resource "aws_instance" "redhat-server" {
  ami                     = "ami-0c7af5fe939f2677f"
  instance_type           = "t3.medium"

  key_name = aws_key_pair.prod-keypair.key_name

  network_interface {
    network_interface_id = aws_network_interface.ni-prod-bastion.id
    device_index = 0
  }
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 30
    volume_type = "gp3"
    }
  
  tags = {
    Name = "redhat-server"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source = "/home/ubuntu/.ssh/id_rsa"
    destination = "/home/ec2-user/key.pem" 
  }

  provisioner "file" {
    source = "/home/ubuntu/redhat_linux/infra-setup-on-aws/script-all-nodes.sh"
    destination = "/home/ec2-user/script-all-nodes.sh" 
  }

  provisioner "file" {
    source = "/home/ubuntu/redhat_linux/infra-setup-on-aws/script-server.sh"
    destination = "/home/ec2-user/script-server.sh" 
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "sudo hostnamectl set-hostname redhat-server",
      "sudo bash /home/ec2-user/script-all-nodes.sh",
      "sudo bash /home/ec2-user/script-server.sh",      
     ]

    }
    depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}


resource "aws_instance" "redhat-client" {
  ami                     = "ami-0c7af5fe939f2677f"
  instance_type           = "t3.medium"
  subnet_id = aws_subnet.prod-vpc_subnet2.id
  key_name = aws_key_pair.prod-keypair.key_name
  vpc_security_group_ids = [ aws_security_group.prod-vpc-SG.id ]
  for_each = var.ec2-instance-names
  root_block_device {
    delete_on_termination = true
    encrypted = false
    iops = 3000
    throughput = 125
    volume_size = 30
    volume_type = "gp3"
    }
  connection {
    bastion_host = aws_instance.redhat-server.public_ip
    bastion_port = "22"
    bastion_private_key = file("~/.ssh/id_rsa")
    type = "ssh"
    bastion_user = "ec2-user"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.private_ip
  }

  provisioner "file" {
    source = "/home/ubuntu/.ssh/id_rsa"
    destination = "/home/ec2-user/key.pem" 
  }

  provisioner "file" {
    source = "/home/ubuntu/redhat_linux/infra-setup-on-aws/script-all-nodes.sh"
    destination = "/home/ec2-user/script-all-nodes.sh" 
  }
  provisioner "file" {
    source = "/home/ubuntu/redhat_linux/infra-setup-on-aws/script-client.sh"
    destination = "/home/ec2-user/script-client.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sudo hostnamectl set-hostname ${each.value}",
      "sudo chmod 600 /home/ec2-user/key.pem",
      "sudo bash /home/ec2-user/script-all-nodes.sh",
      "sudo bash /home/ec2-user/script-client.sh",
     ]    
  }

  tags = {
    Name = each.value
  }
  depends_on = [ aws_vpc.prod-vpc, aws_route_table.public-rt ]
}
