provider "aws" {
  region = "ap-south-1"
}

//--------creating instance for Jenkins server------------
resource "aws_instance" "Jenkins_server" {
  ami           = "ami-0dee22c13ea7a9a67" 
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  user_data = file(var.user_data)
  root_block_device {
    volume_size = var.volume_size
  }
  

  tags = {
    Name = "Jenkins_Server"
  }
}

//crating security group 
resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  vpc_id      = var.sg_vpc_id

  tags = {
    Name = "Jenkins_SG"
  }
}
//inbound rules 
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_port8080" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080  // for jenkins server 
  ip_protocol       = "tcp"
  to_port           = 8080
}
resource "aws_vpc_security_group_ingress_rule" "allow_port9000" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9000 // for sonarqube server 
  ip_protocol       = "tcp"
  to_port           = 9000
}
//outbound rules 
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
//outbond rules for ipv6
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.Jenkins_SG.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}