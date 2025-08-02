#!/bin/bash
paths=$(find /etc -name "conf.d" 2>/dev/null)
for path in $paths
do
           echo $path | sed 's/\//-/g'
done	
