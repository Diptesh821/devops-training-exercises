terraform {
  backend "s3" {
    bucket = "diptesh-bucket01"
    key = "terraform.tfstate"
    region = "eu-north-1"
   }
}


resource "aws_vpc" "MyVpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "diptesh-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.MyVpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.MyVpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVpc.id

  tags = {
    Name = "diptesh-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "diptesh-rt"
  }
}

resource "aws_route_table_association" "rt-a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}




