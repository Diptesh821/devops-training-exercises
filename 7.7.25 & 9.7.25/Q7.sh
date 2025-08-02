#!/bin/bash
bucket_name=diptesh1508
aws s3api put-bucket-policy --bucket ${bucket_name} --policy file://${1}
