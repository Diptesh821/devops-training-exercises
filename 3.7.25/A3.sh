#!/bin/bash
username1="test1"
aws iam create-user --user-name ${username1}
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --user-name ${username1}
echo "AdministratorAccess Policy attached to user ${username1}"
aws iam list-attached-user-policies \
        --user-name ${username1}

cat <<EOF > policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    }
  ]
}
EOF

cat <<EOF > trust_policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::699475915684:user/${username1}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

policy_name="Tester-Policy"
role_name="Tester-role"
policy_arn=$(aws iam create-policy \
    --policy-name ${policy_name} \
    --policy-document file://policy.json \
    --query "Policy.Arn" --output text)
echo "Policy created - Policy Arn : ${policy_arn}"

aws iam create-role \
        --role-name ${role_name} \
        --assume-role-policy-document file://trust_policy.json
aws iam attach-role-policy \
        --policy-arn ${policy_arn} \
        --role-name ${role_name}
echo "Policy ${policy_name} attached to Role ${role_name}"
aws iam list-attached-role-policies --role-name ${role_name}



cat <<EOF > policy2.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:Assume-Role",
      "Resource": "arn:aws:iam:::role/${role_name}"
    }
  ]
}
EOF



username2="test2"
aws iam create-user --user-name ${username2}
group_name=testing
aws iam create-group --group-name ${group_name}
aws iam add-user-to-group --user-name ${username1} --group-name ${group_name}
aws iam add-user-to-group --user-name ${username2} --group-name ${group_name}
echo "Added user ${username1} and ${username2} to group ${group_name}"
policy_arn=$(aws iam create-policy \
    --policy-name role_policy \
    --policy-document file://policy2.json \
    --query "Policy.Arn" --output text)
aws iam attach-group-policy --policy-arn ${policy_arn}  --group-name ${group_name}
echo "Attached role - ${role_name} to the group ${group_name}"
aws iam list-attached-group-policies --group-name ${group_name}
