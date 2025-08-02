#!/bin/bash
folder=$1
latestfile=`ls -t $folder | head -1`
echo $folder
echo $latestfile
if test -s ${folder}/${latestfile}
then
     $(cp ${folder}/${latestfile} ./)
     echo $(grep -o -E '\w+' $latestfile | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
else
     echo "file is empty"

fi
