#!/bin/bash
username=$(grep "session opened for user" /var/log/auth.log | tail -1 | awk '{print $9}' | cut -d'(' -f 1)
echo "last logged in user is : ${username} "
filenames=$(ls -l ~ | awk '$3 == "'"${username}"'" {print $9}')
for file in $filenames
do
	echo "$file"
done	

