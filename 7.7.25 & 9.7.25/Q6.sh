#!/bin/bash
if [ -z "$1" ]
then
     echo "please provide a arguement(filename)"
     exit 1
fi
filename=$1
if [ ! -e "${filename}" ]
then
     echo "file does not exists"
     exit 1
fi
uuid=$(uuidgen | sed 's/-//g')
bucket_name=dipteshsingh-${uuid}
aws s3 mb s3://${bucket_name}
aws s3 cp ./${filename} s3://${bucket_name}/
echo "Contents of the bucket:"
aws s3 ls s3://${bucket_name}
aws s3 rm s3://${bucket_name} --recursive
aws s3 rb s3://${bucket_name}
echo "${bucket_name} deleted"
