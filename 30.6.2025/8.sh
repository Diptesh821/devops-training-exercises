#!/bin/bash
a=myfolder
for value in $a/*
do
   if [ ! -r $value ]
   then
       echo "$value not readbale"
   continue
   fi
   cp $value $a/backup/
done   
      
