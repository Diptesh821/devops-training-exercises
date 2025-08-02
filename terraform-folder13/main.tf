data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  	}
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "tls_private_key" "public_key_pair" {
  algorithm = "RSA"
}

resource "local_file" "public_key_pair" {
   content = tls_private_key.public_key_pair.private_key_pem
   filename = "public_ins_key_pair.pem"
   file_permission = "0400"
}

resource "aws_key_pair" "public_key_pair" {
   key_name = "diptesh-public-key"
   public_key = tls_private_key.public_key_pair.public_key_openssh
}

resource "aws_security_group" "sg_public_ins" {
   name = "allow_ssh_http_public"
   description = "Allow SSH and HTTP inbound traffic to public instance"
   ingress {
     description = "SSH from anywhere"
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "http from everywhere"
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    } 
   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
 }
   tags = {
     Name = "diptesh-sg-public"
   }
}


resource "aws_instance" "public-ins" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]
   key_name = aws_key_pair.public_key_pair.key_name
   provisioner "file"{
      source = "install.sh"
      destination = "install.sh"
     }
   provisioner "remote-exec"{
      inline = [
          "chmod +x install.sh",
          "sudo ./install.sh"
         ]
    }
   connection {
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.public_key_pair.private_key_pem
      host = self.public_ip
     }  
   tags = {
       Name = "public-instance"
      }
}
