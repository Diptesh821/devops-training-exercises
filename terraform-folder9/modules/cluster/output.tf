output "Instance_Id" {
   value = aws_instance.public-ins.id
}

output "Public_Ip" {
   value = aws_instance.public-ins.public_ip
}
