#!/bin/bash
for app in $*
do
	echo "installing $app..."
	sudo apt install -y $app
done	
