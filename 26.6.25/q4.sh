#!/bin/bash
interfaces=$(ifconfig | awk '/^[A-Za-z0-9]/ {print $1}')
ipv4=$(ifconfig | awk '/inet / {print $2}')
subnet=$(ifconfig | awk '/inet / {print $4}' )
broadcast=$(ifconfig | awk '/inet / { if ($6 ~ /^[0-9]/){print $6} else {print "N/A" }}')
count=1
for interface in $interfaces
do
	echo "$interface"
	echo "IPV4 : $(echo $ipv4 | cut -d' ' -f $count)"
	echo "SUBNET MASK: $(echo $subnet | cut -d' ' -f $count)"
	echo "BROADCAST: $(echo $broadcast |  cut -d' ' -f $count)"
	count=$((count+1))
done
