module "vpc"{
    source = "./modules/vpc"
    vpc_name = "diptesh-vpc"
    subnet_name = "Public"
}

output "Vpc_Id"{
   value = module.vpc.Vpc_Id
}

output "Subnet_Id"{
   value = module.vpc.Subnet_Id
}
