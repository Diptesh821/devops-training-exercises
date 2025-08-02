#!/bin/bash
username=DipteshSingh
aws iam create-user --user-name ${username}
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --user-name ${username}
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name ${username}
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --user-name ${username}
aws iam list-attached-user-policies --user-name ${username}
