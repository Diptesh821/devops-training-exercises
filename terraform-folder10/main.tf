module "sg_module" {
   source = "./modules/sg_module"
}

output "Instance-1_Id" {
   value = module.sg_module.Instance_Id_1
}

output "Instance-1_Public_Ip" {
   value = module.sg_module.Public_Ip_1
}

output "Instance-2_Id" {
   value = module.sg_module.Instance_Id_2
}

output "Instance-2_Public_Ip" {
   value = module.sg_module.Public_Ip_2
}

