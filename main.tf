locals {
  ami_id           = "ami-09e67e426f25ce0d7"
  vpc_id           = aws_default_vpc.defaultvpc.id
  ssh_user         = "ubuntu"
  private_key_path = "${path.cwd}/demo.pem"
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_default_vpc" "defaultvpc" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_key_pair" "demo" {

  key_name = "demo"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpwn5X7F5TEP/jnIyhkpUlopnsg7dxidQv1mfQU4tL9ZVQtzRnge2eB1BoBPj1igKcmeYdZX3zz+gkBAsakWDYCzdT4QDEaFYzqSS8v8er39bxu3QIfuDi441YrzJQyAzrs4d12aEEA9Lsx0HZiNe+DFNfm441yP02k9n11Evlqt2RO76r1kESvCA/A1s4QcxY3sQ0zOCZUBWFPWnbvEIQ4QBmBpVqO/+p3ZhI9xiARVW02X13M07ScLye3Coj47emDWFo3rZPGa9n9NTRNSBwl4ZGvKP19BtrPl+HdqgCqWWv2c8RnQtnU3Nnl45YKHuJZu/Elus5CSTMuCqo/2V6cQUvdn8L9iMRmiMiypesjhtpF1fnGdII4ZYwI05seu9iVEpYU7t7gxtyxzLPkQlN6PHVswx3rqJcq4itaSpbGPAeBnriMLqePowtII6SStm7etAZST68vbMMpylbeC2xuhNfkf/HU2GkYiEZ+Bx1E1bs05gk1vAdIRbkhEeNclE= root@ip-172-31-90-126"

}

resource "aws_security_group" "demoaccess" {
  name   = "demoaccess"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "K8Manager" {
  ami                         = local.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.demoaccess.id]
  key_name                    = aws_key_pair.demo.key_name

  tags = {
    Name = "Worker 1"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = local.ssh_user
    private_key = file(local.private_key_path)
    timeout     = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
  }

  provisioner "local-exec" {
    command = "sudo chmod 400 demo.pem"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > myhosts"
  }

}

resource "aws_instance" "Worker" {
  ami                         = local.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.demoaccess.id]
  key_name                    = aws_key_pair.demo.key_name

  tags = {
    Name = "Worker2"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = local.ssh_user
    private_key = file(local.private_key_path)
    timeout     = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]
  }


  provisioner "local-exec" {
    command = "sudo chmod 400 demo.pem"
  }


  provisioner "local-exec" {
    command = "echo ${self.public_ip} > myhosts"
  }

}

