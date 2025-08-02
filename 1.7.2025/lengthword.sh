#!/bin/bash
E_NO_ARGS=65
if [ $# -eq 0 ]
then
	echo "please invoke the script with one or more command line arguements"
	exit $E_NO_ARGS
fi
var01=${@}
echo "var01 = $var01"
echo "lENGTH OF var01 = ${#var01}"
var02="$var01 EFGH28ij"
echo "var02 = $var02"
echo "length of var02 = ${#var02}"
echo "NUmber of command line arguements passed to the script = ${#@}"
echo "number of command line arguements passed to the script = ${#*}"
echo $#
exit 0
