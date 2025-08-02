#!/bin/bash
files=$(find ~  -mtime -7 -name "*.log")
for file in $files
do
   echo "${file}"
   rm ${file}
done      
