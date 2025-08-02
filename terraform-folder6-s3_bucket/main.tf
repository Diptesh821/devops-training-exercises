module "s3_module" {
 source = "./modules/s3_module"
 account_arn = "arn:aws:iam::699475915684:user/piku"
 bucket_name = "diptesh-bucket01"
}

output "my_bucket_name" {
  value = module.s3_module.s3_bucket_name
}

