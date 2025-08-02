#!/bin/bash
bucketName=$1
aws s3 mb s3://${1}
aws s3api put-bucket-encryption \
	--bucket $1 --server-side-encryption-configuration \
	'{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

