#!/bin/bash
if test "$(id -u)" == "0"
then
	echo "this script is running as root"
else 
        echo "this script is not running as root"
        exit 1
fi	
