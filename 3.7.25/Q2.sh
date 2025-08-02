#!/bin/bash
userdetails=$(aws iam create-user --user-name DipteshSingh)
username=$(echo "${userdetails}" | awk '/"UserName"/ {print $2}')
userid=$(echo "${userdetails}" | awk '/"UserId"/ {print $2}')
creation=$(echo "${userdetails}" | awk '/"CreateDate"/ {print $2}')
echo "UserName: ${username}"
echo "UserId: ${userid}"
echo "Creation timestamp: ${creation}"
