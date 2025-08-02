#!/bin/bash
key_pair_name="diptesh"
key_file="${key_pair_name}.pem"
aws ec2 create-key-pair --key-name ${key_pair_name} --query "KeyMaterial" --output text > ${key_file}
echo "Key Pair Created : ${key_file}"
chmod 400 ${key_file}
security_group_id=$(aws ec2 create-security-group --group-name Diptesh --description "My Security Group" --query "GroupId" --output text)
security_group_rules=$(aws ec2 authorize-security-group-ingress \
        --group-id ${security_group_id} \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0)
echo "Security Group Id : ${security_group_id}"

instance_id=$(aws ec2 run-instances \
        --image-id ami-042b4708b1d05f512 \
        --instance-type t3.micro \
        --security-group-ids ${security_group_id} \
        --associate-public-ip-address \
        --key-name ${key_pair_name} \
        --query "Instances[0].InstanceId" --output text)
echo "Instance launched, Instance Id : ${instance_id}"
allocation_id=$(aws ec2 allocate-address --query "AllocationId" --output text)
echo "Elastic Ip Allocation Id : ${allocation_id}"
association_id=$(aws ec2 associate-address --instance-id ${instance_id} --allocation-id ${allocation_id} --query "AssociationId" --output text)
echo "Elastic Ip associated to instance with Id : ${instance_id}"

aws ec2 wait instance-running \
        --instance-ids ${instance_id}
echo "Instance running"
public_ip=$(aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[].Instances[].PublicIpAddress" --output text)
echo "Public Ip of Instance : ${public_ip}"
echo "Connecting to the instance using ssh:"
sleep 50
ssh -o StrictHostKeyChecking=no -i "${key_file}" ubuntu@${public_ip}

