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
  owners = ["099720109477"] # To download the official ubuntu ami we use the owner code of canonical
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
   tags = {
     Name = "diptesh-sg-public"
   }
}



resource "aws_instance" "public-ins1" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]

   tags = {
       Name = "public-instance1"
      }
}



resource "aws_instance" "public-ins2" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]

   tags = {
       Name = "public-instance2"
      }
}

