#!/bin/bash
string="Hello"
if [[ "$string" =~ ^[a-zA-Z0-9] ]]
then	
	echo "string starts with H"
else
        echo "string does not start with H"
fi	
