output "Vpc_Id"{
   value = aws_vpc.MyVpc.id
}

output "Subnet_Id"{
   value = aws_subnet.public.id
}
