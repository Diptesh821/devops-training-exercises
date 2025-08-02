#!/bin/bash
filename=$1
#awk '/ERROR/ {print NR,$0 }' ${filename}
grep -n "ERROR" ${filename}
