#!/bin/bash
sudo apt update -y
sudo apt install -y nfs-kernel-server
sudo mkdir -p /mnt/todo-data
sudo chown nobody:nogroup /mnt/todo-data
echo "/mnt/todo-data *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server

