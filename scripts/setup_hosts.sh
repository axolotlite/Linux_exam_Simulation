#!/bin/bash
#setup hosts file using hosts.env
#-
COUNT=${COUNT:=1}
#-
for num in $(seq 0 $COUNT)
do
	host="HOST_$num"
	echo ${!host} >> /etc/hosts
done
