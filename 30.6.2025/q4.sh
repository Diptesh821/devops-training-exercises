#!/bin/bash
s=$(systemctl status nginx | awk '/Active:/ {print $2}')
if [ $s == "active" ]
then
        echo "Server is Running"
else
        echo "server is not running"
        sudo systemctl start nginx
fi
