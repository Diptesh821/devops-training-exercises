#!/bin/bash
filename="ascript.sh"
if [[ "$filename" =~ \.sh$ ]]
then
	echo "Filename has a .sh expansion"
else
        echo "filename does not have .sh expansion"
fi	
