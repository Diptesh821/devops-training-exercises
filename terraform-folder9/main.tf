module "cluster" {
  source = "./modules/cluster"
}

output "Instance_Id" {
  value = module.cluster.Instance_Id
}

output "Public_Ip" {
  value = module.cluster.Public_Ip
}
