#!/bin/bash
echo -n "Enter 1st number:"
read a
echo -n "Enter 2nd number:"
read b
val=`expr $a + $b`
echo "a+b:$val"
val=`expr $a - $b`
echo "a-b:$val"
val=`expr $a \* $b`
echo "a*b:$val"
if [ $b == 0 ]
then
	echo "Division by 0 not possible"
else
	val=`expr $a / $b`
        echo "a/b:$val"
fi	
	
