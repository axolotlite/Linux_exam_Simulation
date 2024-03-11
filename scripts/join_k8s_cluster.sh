#!/bin/bash
#-
HOSTS_CONFIG=${HOSTS_CONFIG:="/etc/ssh/ssh_config.d/exam.conf"}
USER=${USER:="root"}
LOCATION=${LOCATION:=""}
#-

for host in $(awk '/Host / {print $NF}' $HOSTS_CONFIG)
then
	ssh $host -- kubeadm token create --print-join-command
