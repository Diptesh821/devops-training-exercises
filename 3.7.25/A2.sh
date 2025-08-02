#!/bin/bash
policy_file="policy.json"
trust_policy="trust_policy.json"
policy_name="Tester-Policy"
policy_arn=$(aws iam create-policy \
    --policy-name ${policy_name} \
    --policy-document file://${policy_file} \
    --query "Policy.Arn" --output text)
echo "Policy Arn : ${policy_arn}"
role_name=Tester-role
aws iam create-role \
	--role-name ${role_name} \
        --assume-role-policy-document file://${trust_policy}
aws iam attach-role-policy \
	--policy-arn ${policy_arn} \
	--role-name ${role_name}
echo "Policy ${policy_name} attached to Role ${role_name}"
