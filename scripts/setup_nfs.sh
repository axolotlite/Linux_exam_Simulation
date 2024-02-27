#!/bin/bash
#This is a script that will setup nfs
#
PACKAGES="nfs-utils "
SHARE_DIR="/user-homes"
NETWORK="10.10.10.0/24"
yum install -y nfs-utils

#create users
mkdir $SHARE_DIR
chown nobody:root $SHARE_DIR
chmod o+rx $SHARE_DIR
#setup nfs
systemctl enable --now nfs-server
firewall-cmd --permanent --add-service={nfs,rpc-bind,mountd}
firewall-cmd --reload
echo "$SHARE_DIR $NETWORK(rw,sync)" >> /etc/exports
exportfs -avr
