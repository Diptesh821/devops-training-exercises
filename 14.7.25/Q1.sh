#!/bin/bash
vpcId=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=diptesh-vpc}]' --query "Vpc.VpcId" --output text)
aws ec2 wait vpc-available --vpc-ids ${vpcId}
echo "VPC Id: ${vpcId}"
public_subnet_id=$(aws ec2 create-subnet \
        --vpc-id ${vpcId} \
        --cidr-block 10.0.1.0/24 --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=public}]' --query "Subnet.SubnetId" --output text)
echo "Public Subnet Id : ${public_subnet_id}"
private_subnet_id=$(aws ec2 create-subnet \
        --vpc-id ${vpcId} \
        --cidr-block 10.0.2.0/24 --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=private}]' --query "Subnet.SubnetId" --output text)
echo "Private Subnet Id : ${private_subnet_id}"
internet_gateway_id=$(aws ec2 create-internet-gateway \
        --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=diptesh-igw}]' --query "InternetGateway.InternetGatewayId" --output text)
echo "Internet Gateway Id : ${internet_gateway_id}"
aws ec2 attach-internet-gateway \
        --internet-gateway-id ${internet_gateway_id} \
        --vpc-id ${vpcId}
route_table_id_public=$(aws ec2 create-route-table --vpc-id ${vpcId} --query "RouteTable.RouteTableId" --output text)
echo "Route Table Id-public : ${route_table_id_public}"
associate_route_public=$(aws ec2 associate-route-table --route-table-id ${route_table_id_public} --subnet-id ${public_subnet_id})
echo "Route Table - ${route_table_id_public} associated with public subnet"
create_route_ig=$(aws ec2 create-route --route-table-id ${route_table_id_public} --destination-cidr-block 0.0.0.0/0 --gateway-id ${internet_gateway_id})
echo "Route created for destination 0.0.0.0/0 and target selected as internet gateway"


allocation_id=$(aws ec2 allocate-address --query "AllocationId" --output text)
echo "elastic ip allocation id : ${allocation_id}"
nat_gateway_id=$(aws ec2 create-nat-gateway --subnet-id ${public_subnet_id} --allocation-id ${allocation_id} --query "NatGateway.NatGatewayId" --output text)
echo "Nat Gateway Id : ${nat_gateway_id}"
route_table_id_private=$(aws ec2 create-route-table --vpc-id ${vpcId} --query "RouteTable.RouteTableId" --output text)
echo "Route table id-private - ${route_table_id_private}"
associate_route_private=$(aws ec2 associate-route-table --route-table-id ${route_table_id_private} --subnet-id ${private_subnet_id})
echo "Route Table - ${route_table_id_private} associated with private subnet"
create_route_nat=$(aws ec2 create-route --route-table-id ${route_table_id_private} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${nat_gateway_id})
echo "Route created for destination 0.0.0.0/0 and target selected as nat gateway"
key_pair_name="diptesh"
key_file="${key_pair_name}.pem"
aws ec2 create-key-pair --key-name ${key_pair_name} --query "KeyMaterial" --output text > ${key_file}
echo "Key Pair Created : ${key_file}"
chmod 400 ${key_file}
security_group_id=$(aws ec2 create-security-group --group-name Diptesh --description "My Security Group" --vpc-id ${vpcId} --query "GroupId" --output text)
security_group_rules=$(aws ec2 authorize-security-group-ingress \
        --group-id ${security_group_id} \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0)
echo "Security Group Id : ${security_group_id}"
instance_id=$(aws ec2 run-instances \
        --image-id ami-042b4708b1d05f512 \
        --instance-type t3.micro \
        --subnet-id ${private_subnet_id} \
        --security-group-ids ${security_group_id} \
	--associate-public-ip-address \
        --key-name ${key_pair_name} \
        --query "Instances[0].InstanceId" --output text)
echo "Instance launched, Instance Id : ${instance_id}"
aws ec2 wait instance-running \
        --instance-ids ${instance_id}
echo "Instance running"
public_ip=$(aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[].Instances[].PublicIpAddress" --output text)
echo "Public Ip of Instance : ${public_ip}"
echo "Connecting to the instance using ssh:"
sleep 50
ssh -i "${key_file}" ubuntu@${public_ip}


