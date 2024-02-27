#!/bin/bash
DESC="
This is a script that will setup nfs

SHARE_DIR: the directory where the nfs will be hosted on
NETWORK: the network subnet that should have access to this share
"
#-
PACKAGES=${PACKAGES:="nfs-utils"}
SHARE_DIR=${PACKAGES:="/user-homes"}
NETWORK=${NETWORK:="10.10.10.0/24"}
#-
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
