output "vpc_id" {
  value = aws_vpc.MyVpc.id
}

output "public_subnet_ip" {
  description = "IP of public subnet"
  value       = aws_subnet.public.cidr_block
}

output "private_subnet_ip" {
  description = "Ip of private subnet"
  value = aws_subnet.private.cidr_block
}

output "public_subnet_id" {
  description = "Id of public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Id of private subnet"
  value = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "Internet Gateway Id"
  value = aws_internet_gateway.igw.id
}


output "route_table_id" {
  description = "Route Table Id"
  value = aws_route_table.rt.id
}
