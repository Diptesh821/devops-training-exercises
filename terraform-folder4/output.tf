output "public-instance-ip"{
  value = aws_instance.public-ins.public_ip
}

output "private-instance-ip"{
 value = aws_instance.private-ins.private_ip
}
