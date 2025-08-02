#!/bin/bash
users=$(cat /etc/passwd)
for user in $users
do	
	username=$(echo ${user} | cut -d':' -f 1)
	directory=$(echo ${user} | cut -d':' -f 6)
	if test -e $directory
	then
		echo "username: ${username} | directory: ${directory} exists"
        else
             echo "username: ${username} | directory: ${directory} does not exists"
        fi
done	
