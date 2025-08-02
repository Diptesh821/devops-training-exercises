resource "aws_vpc" "MyVpc" {
   cidr_block = "10.0.0.0/16"
   instance_tenancy = "default"
   tags = {
     Name = var.vpc_name
   }
}

resource "aws_subnet" "public" {
   vpc_id = aws_vpc.MyVpc.id
   cidr_block = "10.0.1.0/24"
   tags = {
     Name = var.subnet_name
    }
}


