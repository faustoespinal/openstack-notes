#!/bin/bash

machine_name=$1

if [[ ( -n "$machine_name" ) ]]; then
   echo "DO THE BOOT $machine_name"

user_data="./cloud-kubeadm.cfg"
nova boot --image centos-7 --flavor m1.medium --security-groups open-sg --nic net-name=private_network --config-drive true --file /home/centos/k8s-keypair.pem=./k8s-keypair.pem --user-data $user_data --key-name k8s-keypair $machine_name 
else
   echo "USAGE: boot-kubeadm <machine_name>"
fi

