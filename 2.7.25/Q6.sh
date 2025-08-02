#!/bin/bash
services=$@
for service in $services
do 
   if [[ $(systemctl status $service 2>/dev/null) ]]
   then
     active=$(systemctl status "$service" | awk '/Active:/ {print $2}')
     if [ $active = "active" ]
     then 
           echo "Service ${service} is active"
     else
           echo "Service ${service} is inactive"
     fi
   else
       echo "service ${service} not installed"
   fi    

done     
