#!/bin/bash
key_pair_name="diptesh"
key_file="${key_pair_name}.pem"
script_file="script2.sh"
aws ec2 create-key-pair --key-name ${key_pair_name} --query "KeyMaterial" --output text > ${key_file}
echo "Key Pair Created : ${key_file}"
chmod 400 ${key_file}
security_group_id=$(aws ec2 create-security-group --group-name Diptesh --description "My Security Group" --query "GroupId" --output text)
security_group_rules=$(aws ec2 authorize-security-group-ingress \
        --group-id ${security_group_id} \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0)
securityGroupRules=$(aws ec2 authorize-security-group-ingress --group-id ${security_group_id} --ip-permissions '[{"IpProtocol": "tcp","FromPort": 80,"ToPort": 80,"IpRanges": [{"CidrIp": "0.0.0.0/0"}]},{ "IpProtocol": "tcp","FromPort": 443,"ToPort": 443,"IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]')
echo "Security Group Id : ${security_group_id}"

instance_id=$(aws ec2 run-instances \
        --image-id ami-042b4708b1d05f512 \
        --instance-type t3.micro \
        --security-group-ids ${security_group_id} \
        --key-name ${key_pair_name} \
	--user-data file://${script_file} \
        --query "Instances[0].InstanceId" --output text)
echo "Instance launched, Instance Id : ${instance_id}"
aws ec2 wait instance-running \
        --instance-ids ${instance_id}
echo "Instance running"
public_ip=$(aws ec2 describe-instances --instance-ids ${instance_id} --query "Reservations[].Instances[].PublicIpAddress" --output text)
echo "Public Ip of Instance : ${public_ip}"
echo ""
echo "Waiting for SSH daemon and Cloud-Init script to complete..."
CLOUD_INIT_COMPLETE=false
MAX_WAIT_SECONDS=600 
WAIT_INTERVAL=10 

echo "Will check for Cloud-Init completion marker in /var/log/cloud-init-output.log"
echo "Expected marker: 'CLOUD-INIT-FINISHED: LAMP components installed'" 
for (( i=0; i<MAX_WAIT_SECONDS; i+=WAIT_INTERVAL ))
do	
    echo "Attempting SSH and checking Cloud-Init status (elapsed: ${i}s / ${MAX_WAIT_SECONDS}s)..."
    # This command attempts to SSH and grep for the marker.
    # It pipes stderr to /dev/null to suppress SSH error messages until it connects.
    if ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=5 -i "${key_file}" ubuntu@${public_ip} "grep -q 'CLOUD-INIT-FINISHED: LAMP components installed' /var/log/cloud-init-output.log" 2>/dev/null
    then	    
         CLOUD_INIT_COMPLETE=true
         echo "Cloud-init script completion marker found! All components should now be installed."
         break
    else
         echo "Cloud-init still running or marker not found. Waiting..."
         sleep "$WAIT_INTERVAL"
    fi
done

if [ "$CLOUD_INIT_COMPLETE" = false ]
then	
    echo "WARNING: Cloud-init script did not complete within ${MAX_WAIT_SECONDS} seconds."
    echo "The instance may still be configuring. Proceeding with SSH, but installation of components may not be completed"
fi
echo ""
echo "IMPORTANT: Once connected via SSH to ubuntu@${public_ip},"
echo "           you will need to manually configure MariaDB, verify LAMP and php."
echo ""
echo "Please run the following commands on the EC2 instance:"
echo "1. Configure MariaDB security:"
echo "   sudo mysql_secure_installation"
echo "   (Follow prompts: Enter for no current password, then set a new strong password, say 'Y' to all security questions.)"
echo "2. Test MariaDB login:"
echo "   mysql -u root -p"
echo "   (Enter your new password. Type 'exit;' to quit the MariaDB prompt.)"
echo "3. Verify Apache and PHP in your web browser:"
echo "   Open http://${public_ip}/ in your browser (should show Apache default page)."
echo "   Open http://${public_ip}/info.php in your browser (should show PHP info page)."
echo "4. IMPORTANT: Remove the phpinfo.php file for security after testing:"
echo "   sudo rm /var/www/html/info.php"
echo ""
echo "Connecting to the instance using ssh:"
echo ""
ssh -o StrictHostKeyChecking=no -i "${key_file}" ubuntu@${public_ip}



