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
echo "Waiting for SSH on public instance-1..."
until ssh -o StrictHostKeyChecking=no -i public_ins_1_key_pair.pem ubuntu@${instance1_public_ip} "echo SSH Ready"
do
  sleep 5
done

echo "ssh is ready"
echo "ssh into Instance-1"
ssh -o StrictHostKeyChecking=no -i public_ins_1_key_pair.pem ubuntu@${instance1_public_ip} <<EOF
sudo mkdir -p /mnt/todo-data
sudo mount -t nfs ${instance2_private_ip}:/mnt/todo-data /mnt/todo-data
git clone https://github.com/docker/getting-started-app.git
cd getting-started-app
cat <<'DOCKERFILE' > dockerfile
FROM node:lts-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
DOCKERFILE
sudo docker build -t getting-started .
sudo docker run -d -p 3000:3000 --name todo-app -v /mnt/todo-data:/etc/todos getting-started
EOF
