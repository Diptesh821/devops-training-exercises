#!/bin/bash
filename="bscript.sh"
if test -s $filename
then
   echo "file is not empty"
else
   echo "file is empty"
fi   
