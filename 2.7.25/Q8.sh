#!/bin/bash
string=$1
if [[ "$string" =~ [0-9] && "$string" =~ [[:punct:]] && ${#string} -ge 8 ]]
then
	echo "${string} is valid"
else
        echo "${string} is not valid"
fi	
