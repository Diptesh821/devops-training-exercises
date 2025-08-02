#!/bin/bash
systemctl status nginx | awk '$1=="Active:"' | awk '{if($2=="active"){print "server is running"} else{print "server is not running"}}'
