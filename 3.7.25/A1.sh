#!/bin/bash
username="test"
aws iam create-user --user-name ${username}
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name ${username}
echo "Administrator access added to user : ${username}"
aws iam list-attached-user-policies \
	--user-name ${username}
