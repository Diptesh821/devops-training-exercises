#!/bin/bash
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=state,Values=available" \
    --query "Images[*].[CreationDate,Name,ImageId,OwnerId]" \
    --output text
