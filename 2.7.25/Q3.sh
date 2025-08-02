#!/bin/bash
disk=$(df / | tail +2 | awk '{print $5}' | cut -d'%' -f 1)
if [ ${disk} -gt 80 ]
then 
     echo "Disk space is greater than 80 percent"
else 
     echo "Disk space is less than 80 percent"
fi   
