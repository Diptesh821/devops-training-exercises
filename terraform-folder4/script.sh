terraform init
terraform plan
terraform apply -auto-approve
public_instance_ip=$(terraform output -raw public-instance-ip)
private_instance_ip=$(terraform output -raw private-instance-ip)

echo "Public Instance Ip : ${public_instance_ip}"
echo "Private Instance Ip : ${private_instance_ip}"

# Wait until terraform state is updated with outputs
echo "Waiting for Terraform to write outputs..."
sleep 10

echo "Waiting for public_ins_key_pair.pem to be created..."
while [ ! -f public_ins_key_pair.pem ]; do
  sleep 1
done
chmod 400 public_ins_key_pair.pem
echo "Waiting for SSH on public instance..."
until ssh -o StrictHostKeyChecking=no -i public_ins_key_pair.pem ubuntu@${public_instance_ip} "echo SSH Ready"; do
  sleep 5
done

echo " SSHing from public to private instance..."
ssh -tt -i public_ins_key_pair.pem ubuntu@${public_instance_ip} \
  "chmod 400 private_ins_key_pair.pem && \
   ssh -tt -o StrictHostKeyChecking=no -i private_ins_key_pair.pem ubuntu@${private_instance_ip}"
