#!/bin/bash
for value in myfolder2/*.txt
do
	mv $value myfolder2/$( basename -s .txt $value ).php
done	
