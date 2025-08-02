output "Instance_1_public_ip" {
  value = aws_instance.public-ins1.public_ip
}
output "Instance_1_private_ip" {
  value = aws_instance.public-ins1.private_ip
}

output "Instance_2_public_ip" {
  value = aws_instance.public-ins2.public_ip
}

output "Instance_2_private_ip" {
  value = aws_instance.public-ins2.private_ip
}

