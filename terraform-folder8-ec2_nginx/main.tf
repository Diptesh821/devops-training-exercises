module "ec2_nginx" {
   source = "./modules/ec2_nginx"
}

output "Public_Ip" {
  value = module.ec2_nginx.Public_Ip
}

output "Instance_Id"{
  value = module.ec2_nginx.Instance_Id
}
