#!/bin/bash
terraform init
terraform plan
terraform apply -auto-approve

sleep 20

instance1_public_ip=$(terraform output -raw Instance_1_public_ip)
instance1_private_ip=$(terraform output -raw Instance_1_private_ip)
instance2_public_ip=$(terraform output -raw Instance_2_public_ip)
instance2_private_ip=$(terraform output -raw Instance_2_private_ip)

chmod 400 public_ins_1_key_pair.pem
echo "Waiting for SSH on public instance..."
until ssh -o StrictHostKeyChecking=no -i public_ins_1_key_pair.pem ubuntu@${instance1_public_ip} "echo SSH Ready"
do	
  sleep 5
done

echo "ssh is ready"
echo "ssh into Instance-1 and pinging Instance-2"
ssh -o StrictHostKeyChecking=no -i public_ins_1_key_pair.pem ubuntu@${instance1_public_ip} "ping -c 4 ${instance2_private_ip}"


