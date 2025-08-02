#!/bin/bash
a=myfolder
for value in $a/*
do
	used=$(df $a | tail -1 | awk '{print $5}' | sed 's/%//')
        if [ $used -gt 90 ]
	then
	   echo "Low disk space"
           break
        fi
	cp -r $value $a/backup/
done       	
         	
