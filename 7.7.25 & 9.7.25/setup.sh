#!/bin/bash
bucket_name="diptesh1508"
access_point_name="diptesh-s"
account_id=$(aws sts get-caller-identity --query "Account" --output text)
aws s3 mb s3://${bucket_name}
access_point_arn=$(aws s3control create-access-point \
	--account-id ${account_id} \
	--bucket ${bucket_name} \
	--name ${access_point_name} --query "AccessPointArn" --output text)
aws s3control put-access-point-policy \
	--account-id ${account_id} \
	--name ${access_point_name} \
	--policy '{
"Statement":[
{
	"Effect":"Allow",
	"Principal":{
	"AWS":"arn:aws:iam::699475915684:user/piku"
},
	"Action":"s3:GetObject",
	"Resource":"'"${access_point_arn}"'/object/*"
}
]
}'
	

