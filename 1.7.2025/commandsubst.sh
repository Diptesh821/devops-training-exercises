#!/bin/bash
DATE=$(date)
echo "Date is $(date)"
echo "Date is $DATE"
USERS=`who | wc -l`
echo "Logged in users are $USERS"
UP=`date;uptime`
echo "UPTIME is $UP"
