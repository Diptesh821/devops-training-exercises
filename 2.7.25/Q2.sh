#!/bin/bash
host=$(hostname)
#ip=$(ifconfig | awk '/inet / {print $2}' | sed '/127.0.0.1/d')
ip=$(ifconfig | awk '/inet / && $2 != "127.0.0.1" {print $2}')
model=$(uname)
mem=$(free | awk '/Mem/ {print $2}')

echo "Hostname: $host"
echo "IP ADDRESS: $ip"
echo "CPU MODEL: $model"
echo "Total memory: $mem"
echo "Disk Usage:"
df | awk '{print $1,$5}'



