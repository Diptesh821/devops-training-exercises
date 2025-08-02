#!/bin/bash
aws ec2 create-key-pair  --key-name MyKeyPair --query "KeyMaterial" --output text > MyKeyPair.pem
SecurityGroupId=$(aws ec2 create-security-group --group-name Diptesh --description "Diptesh Singh" | awk -F'"' '/GroupId/ {print $4}')
echo "Security Group Id: ${SecurityGroupId}"
myIp=$(curl -4 ifconfig.me)
ip="${myIp}/32"
securityGroupRules=$(aws ec2 authorize-security-group-ingress --group-id ${SecurityGroupId} --ip-permissions '[{"IpProtocol": "tcp","FromPort": 22,"ToPort": 22,"IpRanges": [{"CidrIp": "0.0.0.0/0"}]},{ "IpProtocol": "tcp","FromPort": 80,"ToPort": 80,"IpRanges": [{"CidrIp": "'${ip}'"}]}]')
amiId=ami-042b4708b1d05f512
instanceId=$(aws ec2 run-instances --image-id ${amiId} --instance-type t3.micro --security-group-ids ${SecurityGroupId} --associate-public-ip-address --key-name MyKeyPair --query "Instances[0].InstanceId" --output text)
echo "Instance 1 Id: ${instanceId}"
aws ec2 wait instance-running --instance-ids ${instanceId}
echo "Instance 1 is Running."
az=$(aws ec2 describe-instances --instance-ids ${instanceId} --query "Reservations[].Instances[].Placement.AvailabilityZone" --output text)
volumeId=$(aws ec2 create-volume --volume-type gp2 --size 1 --availability-zone ${az} --query "VolumeId" --output text)
aws ec2 wait volume-available --volume-ids ${volumeId}
attachVolume=$(aws ec2 attach-volume --volume-id ${volumeId} --instance-id ${instanceId} --device /dev/sdf)
aws ec2 wait volume-in-use --volume-ids ${volumeId}
echo "Instance 1:"
aws ec2 describe-instances --instance-ids ${instanceId} --query "Reservations[].Instances[].{PublicDns:PublicDnsName,PublicIp:PublicIpAddress}" --output table
terminateInstance=$(aws ec2 terminate-instances --instance-ids ${instanceId})
aws ec2 wait instance-terminated --instance-ids ${instanceId}
echo "Instance 1 terminated"
aws ec2 wait volume-available --volume-ids ${volumeId}
instanceId2=$(aws ec2 run-instances --image-id ${amiId} --instance-type t3.micro --security-group-ids ${SecurityGroupId} --associate-public-ip-address --key-name MyKeyPair --query "Instances[0].InstanceId" --output text)
echo "Instance 2 Id: ${instanceId2}"
aws ec2 wait instance-running --instance-ids ${instanceId2}
echo "Instance 2 is Running."
attachVolume2=$(aws ec2 attach-volume --volume-id ${volumeId} --instance-id ${instanceId2} --device /dev/sdf)
aws ec2 wait volume-in-use --volume-ids ${volumeId}
echo "Instance 2:"
aws ec2 describe-instances --instance-ids ${instanceId2} --query "Reservations[].Instances[].{PublicDns:PublicDnsName,PublicIp:PublicIpAddress}" --output table







