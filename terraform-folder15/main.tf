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
  owners = ["099720109477"]
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
    ingress {
     description = "http from everywhere"
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
     from_port = 3000
     to_port = 3000
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }
   ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.MyVpc.cidr_block]
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


resource "tls_private_key" "public_key_pair2" {
  algorithm = "RSA"
}

resource "local_file" "public_key_pair2" {
   content = tls_private_key.public_key_pair2.private_key_pem
   filename = "public_ins_2_key_pair.pem"
   file_permission = "0400"
}

resource "aws_key_pair" "public_key_pair2" {
   key_name = "diptesh-public-key2"
   public_key = tls_private_key.public_key_pair2.public_key_openssh
}

resource "aws_instance" "public-ins2" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   key_name = aws_key_pair.public_key_pair2.key_name
   subnet_id = aws_subnet.subnet-2.id
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]
   associate_public_ip_address = true
   provisioner "file" {
      source = "install2.sh"
      destination = "install2.sh"
     }
   provisioner "remote-exec" {
      inline = [
          "chmod +x install2.sh",
          "sudo ./install2.sh"
         ]
    }
   connection {
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.public_key_pair2.private_key_pem
      host = self.public_ip
     }  
   tags = {
     Name = "public-instance2"
    }
}


resource "tls_private_key" "public_key_pair1" {
  algorithm = "RSA"
}

resource "local_file" "public_key_pair1" {
   content = tls_private_key.public_key_pair1.private_key_pem
   filename = "public_ins_1_key_pair.pem"
   file_permission = "0400"
}

resource "aws_key_pair" "public_key_pair1" {
   key_name = "diptesh-public-key1"
   public_key = tls_private_key.public_key_pair1.public_key_openssh
}

resource "aws_instance" "public-ins1" {
   ami = data.aws_ami.ubuntu.id
   instance_type = "t3.micro"
   key_name = aws_key_pair.public_key_pair1.key_name
   subnet_id = aws_subnet.subnet-1.id
   vpc_security_group_ids = [aws_security_group.sg_public_ins.id]
   associate_public_ip_address = true
   provisioner "file" {
      source = "install1.sh"
      destination = "install1.sh"
     }
   provisioner "remote-exec" {
      inline = [
          "chmod +x install1.sh",
          "sudo ./install1.sh"
         ]
    }
   connection {
      type = "ssh"
      user = "ubuntu"
      private_key = tls_private_key.public_key_pair1.private_key_pem
      host = self.public_ip
     }  
   tags = {
     Name = "public-instance1"
    }
}





