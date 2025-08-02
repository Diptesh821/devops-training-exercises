terraform {
  backend "s3" {
    bucket = "diptesh-bucket01"
    key = "terraform.tfstate"
    region = "eu-north-1"
   }
}

resource "aws_vpc" "MyVpc" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"
   tags = {
     Name = "diptesh-vpc"
   }
}

resource "aws_subnet" "subnet-1" {
   vpc_id = aws_vpc.MyVpc.id
   cidr_block = "10.0.1.0/24"
   tags = {
     Name = "Subnet-1"
    }
}

resource "aws_subnet" "subnet-2" {
   vpc_id = aws_vpc.MyVpc.id
   cidr_block = "10.0.2.0/24"
   tags = {
     Name = "Subnet-2"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.MyVpc.id
    tags = {
      Name = "diptesh-igw"
     }
}

resource "aws_route_table" "rt-ig" {
  vpc_id = aws_vpc.MyVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "diptesh-rt-ig"
   }
}

resource "aws_route_table_association" "rt-a-subnet-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-ig.id
}

resource "aws_route_table_association" "rt-a-subnet-2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-ig.id
}


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
   name = "allow_ssh_public"
   description = "Allow SSH inbound traffic to public instance"
   vpc_id = aws_vpc.MyVpc.id
   ingress {
     description = "SSH from anywhere"
     from_port = 22
     to_port = 22
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

resource "aws_instance" "public-ins2" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   subnet_id = aws_subnet.subnet-2.id
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]
   associate_public_ip_address = true
   tags = {
     Name = "public-instance2"
    }
}

resource "aws_instance" "public-ins1" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   subnet_id = aws_subnet.subnet-1.id
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]
   associate_public_ip_address = true
   tags = {
     Name = "public-instance1"
    }
}





