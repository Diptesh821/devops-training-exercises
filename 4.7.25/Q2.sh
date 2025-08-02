#!/bin/bash
keyPairName=$(aws ec2 create-key-pair  --key-name MyKeyPair | awk -F'"' '/"KeyName":/ {print $4}')
SecurityGroupId=$(aws ec2 create-security-group --group-name Diptesh --description "Diptesh Singh" | awk -F'"' '/GroupId/ {print $4}')
echo "Security Group Id: ${SecurityGroupId}"
myIp=$(curl -4 ifconfig.me)
ip="${myIp}/32"
echo "Ip: ${ip}"
securityGroupRules=$(aws ec2 authorize-security-group-ingress --group-id ${SecurityGroupId} --ip-permissions '[{"IpProtocol": "tcp","FromPort": 22,"ToPort": 22,"IpRanges": [{"CidrIp": "0.0.0.0/0"}]},{ "IpProtocol": "tcp","FromPort": 80,"ToPort": 80,"IpRanges": [{"CidrIp": "'${ip}'"}]}]')
amiId=ami-042b4708b1d05f512
instanceId=$(aws ec2 run-instances --image-id ${amiId} --instance-type t3.micro --security-group-ids ${SecurityGroupId} --associate-public-ip-address --key-name ${keyPairName} --query "Instances[0].InstanceId" --output text)
echo "Instance Id: ${instanceId}"
aws ec2 wait instance-running --instance-ids ${instanceId}
echo "Instance is Running."
aws ec2 describe-instances --instance-ids ${instanceId} --query "Reservations[].Instances[].{PublicDns:PublicDnsName,PublicIp:PublicIpAddress}" --output table


