#!/bin/bash
process=$1
pss=$(ps -eo pid,%mem,comm | grep ${process})
if [ -z "${pss}" ]
then
     echo "${process} is not running"	
else
     echo "${process} is running"
     echo "$pss" | while read -r p
     do	 
         pids=$(echo "$p" | awk '{print $1}')
         memory=$(echo "$p" | awk '{print $2}')
         echo "Process Name: ${process} | Process ID: ${pids} | Memory : ${memory}"
     done

fi	
     	
