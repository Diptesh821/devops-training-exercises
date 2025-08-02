#!/bin/bash
available_amis=$(aws ec2 describe-images)
echo "${available_amis}" | grep "099720109477" 
