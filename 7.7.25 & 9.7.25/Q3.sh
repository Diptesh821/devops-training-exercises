#!/bin/bash
bucket_name=dipteshsingh2112
aws s3 mb s3://${bucket_name}
aws s3 cp index.html s3://${bucket_name}/
aws s3 cp error.html s3://${bucket_name}/
aws s3 website s3://${bucket_name}/ \
	--index-document index.html \
	--error-document error.html
aws s3api put-public-access-block \
	--bucket ${bucket_name} \
	--public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
aws s3api put-bucket-policy --bucket ${bucket_name} --policy '{
"Statement":[
{
	"Sid":"Allow public access to GetObject",
	"Effect":"Allow",
	"Principal":"*",
	"Action":"s3:GetObject",
	"Resource":"arn:aws:s3:::'${bucket_name}'/*"
	
}
]
}'
bucket_location=$(aws s3api get-bucket-location --bucket ${bucket_name} --query "LocationConstraint" --output text)
url="http://${bucket_name}.s3-website.${bucket_location}.amazonaws.com"
echo "Url: ${url}"
curl ${url}
