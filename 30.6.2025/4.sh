#!/bin/bash
a=myfolder
for value in $a/*.html
do
	cp $value $a/$( basename -s .html $value ).php
done	
