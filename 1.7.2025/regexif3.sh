#!/bin/bash
string="Hello, world!"
if ! [[ "$string" =~ [0-9] ]]
then
      echo "string does not contain any digits"
else
      echo "string contains atleast one digit"
fi      
