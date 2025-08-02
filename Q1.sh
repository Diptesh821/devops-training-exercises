#!/bin/bash
date=$(date "+%m%d%Y")
tar -cf ./backup1.tar  /var/www/ && mv backup1.tar ${date}.tar && mv ${date}.tar /home/diptesh_singh/maintenance
